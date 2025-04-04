// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:treenode/controllers/buypro/BuyProController.dart';
// import 'package:treenode/controllers/utills/ThemeController.dart';
//
// class QRScannerWidget extends StatelessWidget {
//   final BuyProController controller = Get.find<BuyProController>();
//   final ThemeController themeController = Get.find<ThemeController>();
//
//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;
//
//     return IconButton(
//       icon: Icon(Icons.camera_alt),
//       onPressed: () async {
//         if (await controller.requestCameraPermission()) {
//           showModalBottomSheet(
//             context: context,
//             isScrollControlled: true,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(w * 0.1)),
//             ),
//             builder: (context) {
//               return Container(
//
//                 height: h * 0.45,
//                 decoration: BoxDecoration(
//                   color: themeController.isDarkTheme.value
//                       ? const Color.fromRGBO(44, 45, 49, 1)
//                       : const Color.fromRGBO(255, 250, 244, 1),
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(w * 0.1)),
//                 ),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
//                       child: SizedBox(
//                         width: w * 0.9,
//                         height: h * 0.3,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: MobileScanner(
//                             fit: BoxFit.cover,
//                             onDetect: (capture) {
//                               final List<Barcode> barcodes = capture.barcodes;
//                               if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
//                                 controller.updateScannedCode(barcodes.first.rawValue!);
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: w * 0.04),
//                     Obx(() {
//                       bool isScanned = controller.scannedCode.value.isNotEmpty;
//                       return Padding(
//                         padding: EdgeInsets.symmetric(horizontal: w * 0.1),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(15),
//                           child: BackdropFilter(
//                             filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//                             child: Container(
//                               padding: EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: isScanned
//                                     ? Colors.green.withOpacity(0.2)
//                                     : Colors.grey.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(15),
//                                 border: Border.all(
//                                   color: isScanned ? Colors.green : Colors.grey,
//                                   width: 2,
//                                 ),
//                               ),
//                               child: Center(
//                                 child: Row(
//                                   children: [
//                                     Text(
//                                       isScanned
//                                           ? " ${controller.scannedCode.value} اسکن شد!"
//                                           : "در حال اسکن...".tr,
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: isScanned ? Colors.green[900] : Colors.white,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//
//                     SizedBox(height: w * 0.04),
//                   ],
//                 ),
//               );
//             },
//           );
//         } else {
//         }
//       },
//     );
//   }
// }
