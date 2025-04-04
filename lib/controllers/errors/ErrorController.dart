// import 'dart:convert';
// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:path_provider/path_provider.dart';
//
// class ErrorController extends GetxController {
//   RxList<String> errorLogs = <String>[].obs;
//
//   Future<void> logError(String error) async {
//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final filePath = '${directory.path}/error_logs.json';
//       final file = File(filePath);
//       print("${error}");
//       errorLogs.add(error);
//
//       if (await file.exists()) {
//         List<dynamic> existingLogs = jsonDecode(await file.readAsString());
//         existingLogs.add(error);
//         await file.writeAsString(jsonEncode(existingLogs));
//       } else {
//         await file.writeAsString(jsonEncode([error]));
//       }
//     } catch (e) {
//       print("Failed to log error: $e");
//     }
//   }
//
//   Future<List<String>> getErrorLogs() async {
//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final filePath = '${directory.path}/error_logs.json';
//       final file = File(filePath);
//
//       if (await file.exists()) {
//         List<dynamic> logs = jsonDecode(await file.readAsString());
//         return List<String>.from(logs);
//       } else {
//         return [];
//       }
//     } catch (e) {
//       print("Failed to read error logs: $e");
//       return [];
//     }
//   }
//
//   // Method to get logs and send them (as JSON)
//   Future<void> sendErrorLogs() async {
//     try {
//       List<String> logs = await getErrorLogs();
//       // Convert logs to JSON
//       String logsJson = jsonEncode({"error_logs": logs});
//
//       // Here you can send the logs to a server, for example:
//       // await _httpService.sendErrorLogs(logsJson);
//
//       print("Logs to send: $logsJson");
//     } catch (e) {
//       print("Failed to send error logs: $e");
//     }
//   }
// }
