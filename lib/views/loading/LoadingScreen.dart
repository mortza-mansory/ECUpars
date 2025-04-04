import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:treenode/controllers/account/AccountController.dart';
import 'package:treenode/controllers/loading/LoadingController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

class LoadingScreen extends StatelessWidget {
  final LoadingController loadingController = Get.find<LoadingController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final  accessController = Get.put(AccountController);

  @override
  Widget build(BuildContext context) {
    double wscreen = MediaQuery.of(context).size.width;
    double hscreen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (!loadingController.isAnimationFinished.value) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/animate/red.json',
                  width: wscreen * 0.8,
                  height: hscreen * 0.8,
                  fit: BoxFit.contain,
                  repeat: false,
                  onLoaded: (composition) {
                    Future.delayed(composition.duration + Duration(milliseconds: 1), () {
                      loadingController.isAnimationFinished.value = true;
                      loadingController.loadData();
                    });
                  },
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}


