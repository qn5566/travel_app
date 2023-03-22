import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../util/object_util.dart';
import '../util/ui_util.dart';

class NetworkCacheImage extends StatelessWidget {
  final String? url;
  final Widget? placeholder;
  final int? type;
  final double radius;
  final double radiusTopLeft;
  final double radiusTopRight;
  final double radiusBottomLeft;
  final double radiusBottomRight;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget placeholderWidget;
  final Color? placeholderColor;
  final Widget errorWidget;
  final bool showLoading;

  const NetworkCacheImage({
    super.key,
    this.url,
    this.placeholder,
    @Deprecated('this field is useless,Used to be too lazy to change the code that calls the method.')
    this.type,
    this.radius = 0.0,
    this.radiusTopLeft = 0.0,
    this.radiusTopRight = 0.0,
    this.radiusBottomLeft = 0.0,
    this.radiusBottomRight = 0.0,
    this.width,
    this.height,
    this.fit,
    required this.placeholderWidget,
    required this.errorWidget,
    this.showLoading = false,
    this.placeholderColor,
  });

  @override
  Widget build(BuildContext context) {
    return hasRadius()
        ? ClipRRect(
        borderRadius: hasAllRadius()
            ? BorderRadius.all(Radius.circular(radius))
            : BorderRadius.only(
          topLeft: Radius.circular(radiusTopLeft),
          topRight: Radius.circular(radiusTopRight),
          bottomLeft: Radius.circular(radiusBottomLeft),
          bottomRight: Radius.circular(radiusBottomRight),
        ),
        child: _buildImage())
        : _buildImage();
  }

  bool hasRadius() {
    return hasAllRadius() || hasPartRadius();
  }

  bool hasAllRadius() {
    return (radius != null && radius > 0.0);
  }

  //四个角任何一个大于0都表示有圆角
  bool hasPartRadius() {
    return radiusTopLeft > 0.0 ||
        radiusTopRight > 0.0 ||
        radiusBottomLeft > 0.0 ||
        radiusBottomRight > 0.0;
  }

  Widget _buildImage() {
    if (ObjectUtil.isEmpty(url!)) {
      return _buildPlaceholderWidget();
    }
    return CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 500),
        placeholder: (context, s) =>
        placeholderWidget ?? _buildPlaceholderWidget(),
        errorWidget: (context, s, e) {
          return errorWidget ?? _buildErrorWidget();
        });
  }

  Widget _buildPlaceholderWidget() {
    if (placeholder != null) {
      return placeholder!;
    }
    return Container(
      color: placeholderColor ?? Colors.transparent,
      width: width,
      height: height,
      child: showLoading
          ? Center(
        child: SizedBox(
          width: ASize.w(50),
          height: ASize.w(50),
          child: const LoadingIndicator(
            indicatorType: Indicator.circleStrokeSpin,
            // color: Colors.deepPurpleAccent,
          ),
        ),
      )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildErrorWidget() {
    //无须默认错误占位图，跟默认占位图一致
    return placeholderWidget ??
        Container(
          color: Colors.transparent,
          width: width,
          height: height,
        );
  }
}
