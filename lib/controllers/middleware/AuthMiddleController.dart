// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:treenode/controllers/auth/AccessController.dart';
//
// class AuthMiddleware extends GetMiddleware {
//   final AccessController accessController = Get.find();
//
//   @override
//   int? get priority => 1;
//
//   @override
//   RouteSettings? redirect(String? route) {
//     if (accessController.isRedirecting.value) {
//       return null;
//     }
//
//     final isExpired = accessController.isAccessTokenExpiredSync();
//     if (isExpired) {
//       if (route != '/start') {
//         accessController.startRedirect();
//         return const RouteSettings(name: '/start');
//       }
//     }
//
//     return null;
//   }
// }
