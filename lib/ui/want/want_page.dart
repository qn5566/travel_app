import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/ui/want/want_controller.dart';

import '../../util/ad_manager_util.dart';
import '../../util/ui_util.dart';
import '../../widgets/grid_view_all_history.dart';
import '../../widgets/show_confirmation_dialog.dart';

/*
想去名單頁面
*/
class WantPage extends GetView<WantController> {
  const WantPage({super.key});

  /// 刪除全部前的確認
  Future<void> _confirmDeleteAll(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ConfirmationDialog(
        '確定要刪除全部想去名單嗎？',
        onConfirm: (value) => Navigator.of(dialogContext).pop(value),
      ),
    );
    if (confirmed == true) {
      controller.deleteData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 資料載入移至 controller.onInit() / 切換 tab 時 reload()，
    // 不在 build() 內觸發副作用。
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/pics/land_1.webp',
              fit: BoxFit.fitHeight,
              alignment: Alignment.center,
              // 用 color blend 達成半透明，取代 Opacity 的 saveLayer 離屏合成
              color: const Color(0x80FFFFFF),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: ScreenUtil().statusBarHeight + 5.0),
              Obx(() => (controller.isADShowing.value &&
                      controller.bannerAd != null)
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: controller.bannerAd!.size.width.toDouble(),
                        height: controller.bannerAd!.size.height.toDouble(),
                        child: AdManagerUtil()
                            .bannerAdWidget(controller.bannerAd!),
                      ),
                    )
                  : SizedBox(
                      height: ASize.h(0),
                    )),
              SizedBox(
                height: ASize.h(5),
              ),
              Expanded(
                child: GridViewAllHistory(),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Obx(() => (controller.dataAllList.isNotEmpty)
          ? FloatingActionButton.extended(
              heroTag: null, // IndexedStack 內多頁共存，關閉預設 Hero tag 避免重複
              onPressed: () => _confirmDeleteAll(context),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // 設置圓角弧度
              ),
              label: const Text(
                '刪除全部資料',
                style: TextStyle(color: Colors.white),
              ),
            )
          : SizedBox(
              width: ASize.w(1),
            )),
    );
  }
}
