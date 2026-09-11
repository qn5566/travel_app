import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel/ui/splash/splash_controller.dart';

import '../../config/global_config.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SplashController>(builder: (_) {
        return Container(
          color: Colors.black,
          child: Image.asset(
            splashImage,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
        );
      }),
    );
  }
}
