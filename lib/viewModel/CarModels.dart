import '../models/CategoryModel.dart';
import '../services/api/HttpService.dart';

class CarViewModel {
  final HttpService httpService;

  CarViewModel({required this.httpService});

  Future<CategoryModel> fetchCategory(int categoryId) async {
    final response = await httpService.get('api/v1/cars/$categoryId/');
    if (response != null) {
      return CategoryModel.fromJson(response['category']);
    } else {
      throw Exception("Failed to fetch category details.");
    }
  }

  Future<List<CategoryModel>> fetchRelatedCategories(int categoryId) async {
    final response = await httpService.get('api/v1/cars/$categoryId/');
    if (response != null) {
      return (response['all_related_categories'] as List)
          .map((item) => CategoryModel.fromJson(item))
          .toList();
    } else {
      throw Exception("Failed to fetch related categories.");
    }
  }

  Future<List<dynamic>> fetchIssues(int categoryId) async {
    final response = await httpService.get('api/v1/cars/$categoryId/');
    if (response != null) {
      return response['issues'];
    } else {
      throw Exception("Failed to fetch issues.");
    }
  }
}
