// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html_all/flutter_html_all.dart';
// import 'package:treenode/services/api/config/endpoint.dart';
//
// class ImageHtmlExtension implements Extension {
//   @override
//   Map<String, Widget Function(ExtensionContext)> get tags {
//     return {
//       'img': (context) {
//         // Get the 'src' attribute of the <img> tag
//         final src = context.element?.attributes['src'] ?? '';
//
//         String imageUrl = src;
//         if (src.startsWith('/')) {
//           imageUrl = Endpoint.httpAddress + src;
//         }
//
//         // Render the image with the corrected URL.
//         return Image.network(
//           imageUrl,
//           fit: BoxFit.cover,
//           width: double.infinity,
//         );
//       },
//     };
//   }
// }