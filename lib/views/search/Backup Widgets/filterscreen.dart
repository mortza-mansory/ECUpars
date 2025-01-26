// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:searchfield/searchfield.dart';
// import 'package:treenode/controllers/search/SearchController.dart';
// import 'package:treenode/controllers/utills/ThemeController.dart';
//
// class FilterScreen extends StatelessWidget {
//   final SearchingController searchController = Get.find<SearchingController>();
//   final ThemeController themeController = Get.find<ThemeController>();
//   final FocusNode focusNode = FocusNode();
//
//   FilterScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     double h = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: themeController.isDarkTheme.value
//             ? Color.fromRGBO(44, 45, 49, 1)
//             : Color.fromRGBO(255, 250, 244, 1),
//         title: Text(
//           "Filter results".tr,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: h / 38,
//             color: themeController.isDarkTheme.value
//                 ? const Color.fromRGBO(255, 250, 244, 1)
//                 : const Color.fromRGBO(44, 45, 49, 1),
//           ),
//         ),
//         leading: IconButton(onPressed: (){     Get.back();}, icon: Icon(Icons.arrow_back_ios_sharp,color:  themeController.isDarkTheme.value
//             ?Colors.white
//             : Colors.black,)),
//         actions: [
//           Padding(
//             padding: EdgeInsets.fromLTRB(h * 0.015, 0, h * 0.015, 0),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 fixedSize: Size(h * 0.13, h * 0.05),
//                 backgroundColor: themeController.isDarkTheme.value
//                     ? const Color.fromRGBO(255, 250, 244, 1)
//                     : const Color.fromRGBO(44, 45, 49, 1),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(40),
//                 ),
//                 padding: EdgeInsets.symmetric(
//                     horizontal: h * 0.02, vertical: h * 0.01),
//               ),
//               onPressed: () {
//                 searchController.applyFilters();
//                 Get.back();
//               },
//               child: Text(
//                 "Apply".tr,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontFamily: 'Sarbaz',
//                   fontSize: h / 55,
//                   color: themeController.isDarkTheme.value
//                       ? const Color.fromRGBO(44, 45, 49, 1)
//                       : const Color.fromRGBO(255, 250, 244, 1),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Obx(() {
//         return Padding(
//           padding: EdgeInsets.fromLTRB(h * 0.008, 0, h * 0.008, 0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(
//                       left: h * 0.02, right: h * 0.02, top: h * 0.02),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         "General Searching".tr,
//                         textAlign: TextAlign.start,
//                         style: TextStyle(
//                           fontSize: h / 40,
//                           color: themeController.isDarkTheme.value
//                               ? const Color.fromRGBO(255, 250, 244, 1)
//                               : const Color.fromRGBO(44, 45, 49, 1),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: h * 0.02),
//                 Obx(() => Row(
//                   children: [
//                     Radio<String>(
//                       value: "Yes",
//                       groupValue: searchController.selectedCategory.value,
//                       activeColor: themeController.isDarkTheme.value
//                           ? Colors.white
//                           : Colors.black,
//                       onChanged: (value) {
//                         //        searchController.updateCategories([value!]);
//                       },
//                     ),
//                     Text(
//                       "Yes",
//                       style: TextStyle(
//                         color: themeController.isDarkTheme.value
//                             ? const Color.fromRGBO(255, 250, 244, 1)
//                             : const Color.fromRGBO(44, 45, 49, 1),
//                       ),
//                     ),
//                     Radio<String>(
//                       value: "No",
//                       groupValue: searchController.selectedCategory.value,
//                       activeColor: themeController.isDarkTheme.value
//                           ? Colors.white
//                           : Colors.black,
//                       onChanged: (value) {
//                         ///      searchController.updateCategories([value!]);
//                       },
//                     ),
//                     Text(
//                       "No",
//                       style: TextStyle(
//                         color: themeController.isDarkTheme.value
//                             ? const Color.fromRGBO(255, 250, 244, 1)
//                             : const Color.fromRGBO(44, 45, 49, 1),
//                       ),
//                     ),
//                   ],
//                 )),
//                 SizedBox(height: h * 0.02),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(h * 0.015, 0, h * 0.015, 0),
//                   child: Obx(() => SearchField(
//                     focusNode: focusNode
//                       ..addListener(() {
//                         if (focusNode.hasFocus) {
//                           searchController.fetchCategories();
//                         }
//                       }),
//                     suggestions: searchController.isLoadingCategories.value
//                         ? []
//                         : searchController.categories
//                         .map((category) => SearchFieldListItem(
//                       searchController.decodeUnicode(category['text'] as String),
//                       child: Text(
//                         searchController.decodeUnicode(category['text'] as String),
//                         style: TextStyle(
//                           color: themeController.isDarkTheme.value
//                               ? Colors.white
//                               : Colors.black,
//                         ),
//                       ),
//                     ))
//                         .toList(),
//                     suggestionState: Suggestion.expand,
//                     searchInputDecoration: SearchInputDecoration(
//                       hintText: "Search categories...".tr,
//                       prefixIcon: searchController.isLoadingCategories.value
//                           ? SizedBox(
//                         height: h * 0.003,
//                         width: h * 0.003,
//                         child: CircularProgressIndicator(
//                           strokeWidth: h * 0.005,
//                           color: Colors.grey,
//                         ),
//                       )
//                           : Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     suggestionsDecoration: SuggestionDecoration(
//                       padding: EdgeInsets.fromLTRB(h*0.02, h*0.005, h*0.02, 0),
//                       color: themeController.isDarkTheme.value
//                           ? const Color.fromRGBO(30, 30, 35, 1)
//                           : const Color.fromRGBO(245, 245, 250, 1),
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 10,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     onSuggestionTap: (suggestion) {
//                       final selectedCategory = searchController.categories.firstWhere(
//                               (category) =>
//                           searchController.decodeUnicode(category['text'] as String) ==
//                               suggestion.searchKey);
//                       searchController.addCategory(selectedCategory);
//                     },
//                   )),
//                 ),
//
//
//                 SizedBox(
//                   height: h * 0.02,
//                 ),
//                 Wrap(
//                   spacing: h * 0.01,
//                   children: searchController.allSelectedCategories
//                       .map((category) => Chip(
//                     label:
//                     Text(searchController.decodeUnicode(category)),
//                     onDeleted: () {
//                       searchController.removeCategory(category);
//                     },
//                   ))
//                       .toList(),
//                 ),
//                 const Divider(),
//                 ...searchController.allSelectedCategories.map((category) {
//                   int? categoryId = searchController.categoryIdMap[category];
//
//                   return categoryId != null
//                       ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Obx(() {
//                         if (searchController
//                             .isLoadingSubcategories.value) {
//                           return Center(
//                               child: CircularProgressIndicator());
//                         }
//
//                         var subcategories = searchController
//                             .subcategoriesByCategory[categoryId] ??
//                             [];
//
//                         // if (subcategories.isEmpty) {
//                         //   return Padding(
//                         //     padding: const EdgeInsets.all(8.0),
//                         //     child: Text("No subcategories available.".tr),
//                         //   );
//                         // }
//
//                         return Wrap(
//                           spacing: h * 0.01,
//                           children: subcategories.map((subcategory) {
//                             String subcategoryName = subcategory['name'];
//                             return ChoiceChip(
//                               label: Text(searchController
//                                   .decodeUnicode(subcategoryName)),
//                               selected: searchController
//                                   .selectedSubcategories
//                                   .contains(subcategoryName),
//                               onSelected: (_) {
//                                 searchController
//                                     .toggleSubcategory(subcategoryName);
//                               },
//                             );
//                           }).toList(),
//                         );
//                       }),
//                     ],
//                   )
//                       : Container();
//                 }),
//                 if (searchController.selectedSubcategories.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.all(h * 0.02),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text("Selected Filters".tr),
//                           ],
//                         ),
//                       ),
//                       Wrap(
//                         spacing: h * 0.02,
//                         children: searchController.selectedSubcategories
//                             .map((subcategory) => Chip(
//                           label: Text(searchController
//                               .decodeUnicode(subcategory)),
//                           onDeleted: () {
//                             searchController
//                                 .toggleSubcategory(subcategory);
//                           },
//                         ))
//                             .toList(),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
