import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class SavedController extends GetxController {
  final GetStorage _storage = GetStorage();

  final RxList<int> savedIssueIds = <int>[].obs;
  final RxMap<int, Map<String, dynamic>> savedIssues = <int, Map<String, dynamic>>{}.obs;

  final RxList<int> savedStepIds = <int>[].obs;
  final RxMap<int, Map<String, dynamic>> savedSteps = <int, Map<String, dynamic>>{}.obs;

  final RxList<int> savedMapIds = <int>[].obs;
  final RxMap<int, Map<String, dynamic>> savedMaps = <int, Map<String, dynamic>>{}.obs;

  final RxList<int> savedArticleIds = <int>[].obs;
  final RxMap<int, Map<String, dynamic>> savedArticles = <int, Map<String, dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedIssues();
    _loadSavedSteps();
    _loadSavedMaps();
    _loadSavedArticles();
  }

  // Load Methods
  void _loadSavedIssues() {
    final saved = _storage.read('savedIssues') ?? {};
    if (saved is Map<String, dynamic>) {
      savedIssues.assignAll(saved.map((key, value) {
        final issueId = int.tryParse(key) ?? -1;
        final decodedValue = _decodeIssueMap(Map<String, dynamic>.from(value));
        print("Loaded issue $issueId: $decodedValue"); // Debug log
        return MapEntry(issueId, decodedValue);
      }));
      savedIssueIds.assignAll(savedIssues.keys.toList());
    }
  }

  void _loadSavedSteps() {
    final saved = _storage.read('savedSteps') ?? {};
    if (saved is Map<String, dynamic>) {
      savedSteps.assignAll(saved.map((key, value) {
        final stepId = int.tryParse(key) ?? -1;
        final decodedValue = _decodeStepMap(Map<String, dynamic>.from(value));
        print("Loaded step $stepId: $decodedValue"); // Debug log
        return MapEntry(stepId, decodedValue);
      }));
      savedStepIds.assignAll(savedSteps.keys.toList());
    }
  }

  void _loadSavedMaps() {
    final saved = _storage.read('savedMaps') ?? {};
    if (saved is Map<String, dynamic>) {
      savedMaps.assignAll(saved.map((key, value) {
        final mapId = int.tryParse(key) ?? -1;
        final decodedValue = _decodeMapMap(Map<String, dynamic>.from(value));
        print("Loaded map $mapId: $decodedValue"); // Debug log
        return MapEntry(mapId, decodedValue);
      }));
      savedMapIds.assignAll(savedMaps.keys.toList());
    }
  }

  void _loadSavedArticles() {
    final saved = _storage.read('savedArticles') ?? {};
    if (saved is Map<String, dynamic>) {
      savedArticles.assignAll(saved.map((key, value) {
        final articleId = int.tryParse(key) ?? -1;
        final decodedValue = _decodeArticleMap(Map<String, dynamic>.from(value));
        print("Loaded article $articleId: $decodedValue"); // Debug log
        return MapEntry(articleId, decodedValue);
      }));
      savedArticleIds.assignAll(savedArticles.keys.toList());
    }
  }

  // Toggle Save Methods
  void toggleSaveIssue(int issueId, Map<String, dynamic> issue, Map<String, dynamic> question) {
    if (isIssueSaved(issueId)) {
      removeIssue(issueId);
    } else {
      _saveIssue(issueId, issue, question);
    }
  }

  void toggleSaveStep(int stepId, Map<String, dynamic> step, Map<String, dynamic> question) {
    if (isStepSaved(stepId)) {
      removeStep(stepId);
    } else {
      _saveStep(stepId, step, question);
    }
  }

  void toggleSaveMap(int mapId, Map<String, dynamic> mapData) {
    if (isMapSaved(mapId)) {
      removeMap(mapId);
    } else {
      _saveMap(mapId, mapData);
    }
  }

  void toggleSaveArticle(int articleId, Map<String, dynamic> articleData) {
    if (isArticleSaved(articleId)) {
      removeArticle(articleId);
    } else {
      _saveArticle(articleId, articleData);
    }
  }

  // Save Methods
  void _saveIssue(int issueId, Map<String, dynamic> issue, Map<String, dynamic> question) {
    savedIssues[issueId] = {
      'issue': _encodeMap(issue),
      'question': _encodeMap(question),
      'savedAt': DateTime.now().toIso8601String(),
    };
    _storage.write('savedIssues', savedIssues.map((key, value) => MapEntry(key.toString(), value)));
    savedIssueIds.add(issueId);
    print("Saved issue $issueId: ${savedIssues[issueId]}"); // Debug log
  }

  void _saveStep(int stepId, Map<String, dynamic> step, Map<String, dynamic> question) {
    savedSteps[stepId] = {
      'step': _encodeMap(step),
      'question': _encodeMap(question),
      'savedAt': DateTime.now().toIso8601String(),
    };
    _storage.write('savedSteps', savedSteps.map((key, value) => MapEntry(key.toString(), value)));
    savedStepIds.add(stepId);
    print("Saved step $stepId: ${savedSteps[stepId]}"); // Debug log
  }

  void _saveMap(int mapId, Map<String, dynamic> mapData) {
    savedMaps[mapId] = {
      'map': _encodeMap(mapData),
      'savedAt': DateTime.now().toIso8601String(),
    };
    _storage.write('savedMaps', savedMaps.map((key, value) => MapEntry(key.toString(), value)));
    savedMapIds.add(mapId);
    print("Saved map $mapId: ${savedMaps[mapId]}");
  }

  void _saveArticle(int articleId, Map<String, dynamic> articleData) {
    print("Raw article data before encoding: $articleData");
    savedArticles[articleId] = {
      'article': _encodeMap(articleData),
      'savedAt': DateTime.now().toIso8601String(),
    };
    _storage.write('savedArticles', savedArticles.map((key, value) => MapEntry(key.toString(), value)));
    savedArticleIds.add(articleId);
    print("Saved article $articleId: ${savedArticles[articleId]}");
  }

  // Remove Methods
  void removeIssue(int issueId) {
    savedIssues.remove(issueId);
    _storage.write('savedIssues', savedIssues.map((key, value) => MapEntry(key.toString(), value)));
    savedIssueIds.remove(issueId);
  }

  void removeStep(int stepId) {
    savedSteps.remove(stepId);
    _storage.write('savedSteps', savedSteps.map((key, value) => MapEntry(key.toString(), value)));
    savedStepIds.remove(stepId);
  }

  void removeMap(int mapId) {
    savedMaps.remove(mapId);
    _storage.write('savedMaps', savedMaps.map((key, value) => MapEntry(key.toString(), value)));
    savedMapIds.remove(mapId);
  }

  void removeArticle(int articleId) {
    savedArticles.remove(articleId);
    _storage.write('savedArticles', savedArticles.map((key, value) => MapEntry(key.toString(), value)));
    savedArticleIds.remove(articleId);
  }

  // Check Saved Status
  bool isIssueSaved(int issueId) => savedIssueIds.contains(issueId);
  bool isStepSaved(int stepId) => savedStepIds.contains(stepId);
  bool isMapSaved(int mapId) => savedMapIds.contains(mapId);
  bool isArticleSaved(int articleId) => savedArticleIds.contains(articleId);

  // Encoding Method (Uniform for all types)
  Map<String, dynamic> _encodeMap(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is String) {
        return MapEntry(key, base64.encode(utf8.encode(value)));
      } else if (value is List) {
        return MapEntry(key, jsonEncode(value));
      } else if (value is Map<String, dynamic>) {
        return MapEntry(key, _encodeMap(value));
      } else {
        return MapEntry(key, value);
      }
    });
  }

  // Separate Decoding Methods for Each Type
  Map<String, dynamic> _decodeIssueMap(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is String) {
        try {
          final decodedString = utf8.decode(base64.decode(value), allowMalformed: true);
          return MapEntry(key, decodedString);
        } catch (e) {
          try {
            return MapEntry(key, jsonDecode(value));
          } catch (e) {
            return MapEntry(key, value); // Fallback to raw value
          }
        }
      } else if (value is Map<String, dynamic>) {
        return MapEntry(key, _decodeIssueMap(value));
      } else {
        return MapEntry(key, value);
      }
    });
  }

  Map<String, dynamic> _decodeStepMap(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is String) {
        try {
          final decodedString = utf8.decode(base64.decode(value), allowMalformed: true);
          return MapEntry(key, decodedString);
        } catch (e) {
          try {
            return MapEntry(key, jsonDecode(value));
          } catch (e) {
            return MapEntry(key, value); // Fallback to raw value
          }
        }
      } else if (value is Map<String, dynamic>) {
        return MapEntry(key, _decodeStepMap(value));
      } else {
        return MapEntry(key, value);
      }
    });
  }

  Map<String, dynamic> _decodeMapMap(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is String) {
        try {
          final decodedString = utf8.decode(base64.decode(value), allowMalformed: true);
          return MapEntry(key, decodedString);
        } catch (e) {
          try {
            return MapEntry(key, jsonDecode(value));
          } catch (e) {
            return MapEntry(key, value); // Fallback to raw value
          }
        }
      } else if (value is Map<String, dynamic>) {
        return MapEntry(key, _decodeMapMap(value));
      } else {
        return MapEntry(key, value);
      }
    });
  }

  Map<String, dynamic> _decodeArticleMap(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is String) {
        try {
          // Step 1: Decode Base64 to get the corrupted string
          final base64Decoded = base64.decode(value);
          final initialDecodedString = utf8.decode(base64Decoded, allowMalformed: true);
          print("Raw Base64 for $key: $value");
          print("Initial Decoded UTF-8 for $key: $initialDecodedString");

          // Step 2: Reinterpret the corrupted string as UTF-8
          // Convert the string to its raw bytes (assuming it was misinterpreted as Latin-1)
          final corruptedBytes = initialDecodedString.codeUnits.map((unit) => unit.toUnsigned(8)).toList();
          final fixedString = utf8.decode(corruptedBytes, allowMalformed: true);
          print("Fixed UTF-8 for $key: $fixedString");

          return MapEntry(key, fixedString);
        } catch (e) {
          print("Error decoding $key: $e, value: $value");
          try {
            return MapEntry(key, jsonDecode(value));
          } catch (e) {
            return MapEntry(key, value); // Fallback to raw value
          }
        }
      } else if (value is Map<String, dynamic>) {
        return MapEntry(key, _decodeArticleMap(value)); // Keep it consistent, use _decodeArticleMap recursively
      } else {
        return MapEntry(key, value);
      }
    });
  }
  Map<String, dynamic> decodeItemData(String type, Map<String, dynamic> data) {
    Map<String, dynamic> decodedData;
    switch (type) {
      case 'issue':
        decodedData = _decodeIssueMap(data);
        break;
      case 'step':
        decodedData = _decodeStepMap(data);
        break;
      case 'map':
        decodedData = _decodeMapMap(data);
        break;
      case 'article':
        decodedData = _decodeArticleMap(data);
        break;
      default:
        decodedData = data;
    }

    return _removeHtmlTags(decodedData);
  }

  Map<String, dynamic> _removeHtmlTags(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is String) {
        final cleanedString = value.replaceAll(RegExp(r'<[^>]+>'), '');
        print("Cleaned $key: $cleanedString (was $value)");
        return MapEntry(key, cleanedString);
      } else if (value is Map<String, dynamic>) {
        return MapEntry(key, _removeHtmlTags(value));
      } else {
        return MapEntry(key, value);
      }
    });
  }
}