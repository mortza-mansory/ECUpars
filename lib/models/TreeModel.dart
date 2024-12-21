import 'package:treenode/models/IssusModel.dart';

import 'CategoryModel.dart';

class TreeModel {
  final CategoryModel category;
  final List<CategoryModel> allRelatedCategories;
  final List<IssueModel> issues;

  TreeModel({
    required this.category,
    required this.allRelatedCategories,
    required this.issues,
  });

  factory TreeModel.fromJson(Map<String, dynamic> json) {
    return TreeModel(
      category: CategoryModel.fromJson(json['category']),
      allRelatedCategories: (json['all_related_categories'] as List)
          .map((item) => CategoryModel.fromJson(item))
          .toList(),
      issues: (json['issues'] as List)
          .map((item) => IssueModel.fromJson(item))
          .toList(),
    );
  }
}

