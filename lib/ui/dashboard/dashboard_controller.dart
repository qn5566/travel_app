import 'dart:async';

import 'package:get/get.dart';

import '../../config/global_config.dart';
import '../../data/repo/data_repo.dart';
import '../../widgets/data_update_dialog.dart';
import '../history/history_controller.dart';
import '../home/home_controller.dart';
import '../map/map_controller.dart';
import '../want/want_controller.dart';

class DashboardController extends GetxController {
  var tabIndex = 0;

  /// 上次下載超過此時間 → 彈窗提醒更新
  static const Duration dataStaleThreshold = Duration(days: 14);

  /// 資料更新彈窗狀態（供 DataUpdateDialog 監聽）
  final updatePhase = DataUpdatePhase.asking.obs;
  final updateProgress = 0.0.obs;
  final updateStatus = ''.obs;

  /// 下載中保底推進的 ticker（onProgress 可能被共用的下載 future 佔用）
  Timer? _updateUiTicker;

  @override
  void onInit() {
    super.onInit();
    _checkDataFreshness();
  }

  @override
  void onClose() {
    _updateUiTicker?.cancel();
    super.onClose();
  }

  /// 進入 Dashboard 後檢查上次下載時間，超過 [dataStaleThreshold] 跳更新提醒
  Future<void> _checkDataFreshness() async {
    // 等 Splash 導航與地圖頁初始下載穩定，避免彈窗與全螢幕下載重疊
    await Future.delayed(const Duration(seconds: 3));
    if (isClosed) return;

    // 從未成功下載過 → 不提醒（地圖頁會引導首次下載）
    final updateTime = sharedPreferences.getString(AppConstants.homeUpdateShareKey);
    if (updateTime == null || updateTime.isEmpty) return;
    final lastUpdate = DateTime.tryParse(updateTime);
    if (lastUpdate == null) return;
    if (DateTime.now().difference(lastUpdate) < dataStaleThreshold) return;

    // 地圖頁正在全螢幕下載（首次安裝 / 版本升級）→ 不打擾
    if (Get.isRegistered<MapController>() &&
        Get.find<MapController>().firstLoading.value) {
      return;
    }

    updatePhase.value = DataUpdatePhase.asking;
    Get.dialog(
      barrierDismissible: false,
      DataUpdateDialog(
        phase: updatePhase,
        progress: updateProgress,
        status: updateStatus,
        onConfirm: confirmUpdate,
        onDismiss: dismissUpdateDialog,
        onRetry: confirmUpdate,
      ),
    );
  }

  /// 使用者按「好」：原地顯示進度條並下載，完成後刷新畫面
  Future<void> confirmUpdate() async {
    updatePhase.value = DataUpdatePhase.downloading;
    updateStatus.value = '正在下載景點資料…';
    updateProgress.value = 0.1;

    // onProgress 只會回報給第一個發起下載的呼叫端；若這次下載與地圖頁共用
    // future，這裡就沒有回調可用，先用保底 ticker 讓 UI 持續前進。
    _updateUiTicker?.cancel();
    _updateUiTicker = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (updateProgress.value < 0.8) {
        updateProgress.value =
            (updateProgress.value + 0.01).clamp(0.1, 0.8).toDouble();
      }
    });

    try {
      await Get.find<DataController>().fetchRemoteData(
        onProgress: (value) {
          // 保留下載/解壓階段在 90% 內，其餘留給 SQLite 寫入
          updateProgress.value = value.clamp(0.1, 0.9).toDouble();
        },
      );
      updateStatus.value = '正在建立離線資料…';
      await _refreshAfterUpdate();
      updateProgress.value = 1;
      updatePhase.value = DataUpdatePhase.done;
      await Future.delayed(const Duration(milliseconds: 800));
      if (Get.isDialogOpen ?? false) Get.back();
    } catch (_) {
      updatePhase.value = DataUpdatePhase.failed;
      updateStatus.value = '下載失敗，請檢查網路後重試';
    } finally {
      _updateUiTicker?.cancel();
    }
  }

  /// 關閉彈窗（「不用」/ 失敗「關閉」）
  void dismissUpdateDialog() {
    if (Get.isDialogOpen ?? false) Get.back();
  }

  /// 下載完成後刷新地圖與首頁
  Future<void> _refreshAfterUpdate() async {
    if (Get.isRegistered<MapController>()) {
      await Get.find<MapController>().fetchDB();
    }
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().fetchDB();
    }
  }

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
    // IndexedStack 的分頁不會因切換而重建；這兩頁的資料可能在詳情頁
    // 被增刪（加入/刪除想去名單），回到該分頁時刷新一次。
    if (index == 2 && Get.isRegistered<WantController>()) {
      Get.find<WantController>().reload();
    }
    if (index == 3 && Get.isRegistered<HistoryController>()) {
      Get.find<HistoryController>().reload();
    }
  }
}
