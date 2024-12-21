import 'api/HttpService.dart';

class Com {
  final HttpService httpService;

  Com({required this.httpService});

  Future<void> login(String username, String password) async {
    await httpService.login(username, password);
  }

  Future<bool> verifyOtp(int otp) async {
    return await httpService.verifyOtp(otp);
  }


  Future<List<Map<String, dynamic>>> fetchRelatedCategories(int categoryId) async {
    final response = await httpService.get('api/v1/cars/$categoryId/');
    if (response != null) {
      return List<Map<String, dynamic>>.from(response['all_related_categories']);
    } else {
      throw Exception("Failed to fetch related categories.");
    }
  }

  Future<List<Map<String, dynamic>>> fetchCategoryIssues(int categoryId) async {
    final response = await httpService.get('api/v1/cars/$categoryId/');
    if (response != null) {
      return List<Map<String, dynamic>>.from(response['issues']);
    } else {
      throw Exception("Failed to fetch issues for the category.");
    }
  }

  Future<Map<String, dynamic>> fetchIssueDetails(int issueId) async {
    final response = await httpService.get('api/v1/issues/$issueId/');
    if (response != null) {
      return response['issue'];
    } else {
      throw Exception("Failed to fetch issue details.");
    }
  }

  Future<Map<String, dynamic>> fetchStepDetails(int stepId) async {
    final response = await httpService.get('api/v1/steps/$stepId/');
    if (response != null) {
      return response['step'];
    } else {
      throw Exception("Failed to fetch step details.");
    }
  }

  Future<List<Map<String, dynamic>>> fetchStepOptions(int stepId) async {
    final response = await httpService.get('api/v1/steps/$stepId/');
    if (response != null) {
      return List<Map<String, dynamic>>.from(response['options']);
    } else {
      throw Exception("Failed to fetch step options.");
    }
  }

}
