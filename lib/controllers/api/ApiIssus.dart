import 'package:get/get.dart';
import 'package:treenode/services/api/HttpService.dart';
import 'package:treenode/services/com.dart';

class IssuesController extends GetxController {
  var issues = <dynamic>[].obs;

  final HttpService httpService = HttpService();
  final Com com = Com(httpService: HttpService());

  final Map<int, List<dynamic>> issuesCache = {};

  Future<bool> loadIssues(int categoryId, {bool forceRefresh = false}) async {
    if (!forceRefresh && issuesCache.containsKey(categoryId)) {
      issues.assignAll(issuesCache[categoryId] ?? <dynamic>[]);
      return true;
    }

    try {
      final Map<dynamic, dynamic> data = await httpService.fetchCategoryDetails(categoryId, true, true);
      final List<dynamic> fetchedIssues = List<dynamic>.from(data['issues'] ?? []);

      issues.assignAll(fetchedIssues);

      issuesCache[categoryId] = fetchedIssues;

      return true;
    } catch (e) {
      print("E. load issues: $e");
      return false;
    }
  }

  void clearIssuesCache(int categoryId) {
    issuesCache.remove(categoryId);
  }

  void clearAllCache() {
    issuesCache.clear();
  }
}
