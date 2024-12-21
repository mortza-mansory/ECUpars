import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:treenode/controllers/loading/LoadingController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

class LoadingScreen extends StatelessWidget {
  final LoadingController loadingController = Get.find<LoadingController>();
  final ThemeController themeController = Get.find<ThemeController>();

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



// class LoadingScreen extends StatelessWidget {
//   final LoadingController loadingController = Get.find<LoadingController>();
//   final ThemeController themeController = Get.find<ThemeController>();
//
//   @override
//   Widget build(BuildContext context) {
//     double wscreen = MediaQuery.of(context).size.width;
//     double hscreen = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Obx(() {
//         if (loadingController.isCheckingConnection.value) {
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Center(
//                 child: Lottie.asset(
//                   'assets/animate/red.json',
//                   width: wscreen *0.6,
//                   height: hscreen * 0.6,
//                   fit: BoxFit.contain,
//                   repeat: false,
//                   onLoaded: (composition) {
//                     Future.delayed(composition.duration, () {
//                       loadingController.checkInternetConnection();
//                     });
//                   },
//                 ),
//               ),
//               SizedBox(height: hscreen * 0.2),
//               Obx(() => Text(
//                 loadingController.loadingMessage.value,
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w400,
//                 ),
//               )),
//               if (loadingController.isLoadingData.value) ...[
//                 SizedBox(height: hscreen * 0.1),
//                 CircularProgressIndicator(color: Colors.white),
//               ],
//             ],
//           );
//         } else if (!loadingController.isConnected.value) {
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Text(
//                 'No Internet Connection',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               SizedBox(height: hscreen * 0.1),
//               ElevatedButton(
//                 onPressed: loadingController.retryConnection,
//                 child: Text('Retry'),
//               ),
//             ],
//           );
//         } else {
//           return SizedBox();
//         }
//       }),
//     );
//   }
// }
