import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'config/endpoint.dart';

class HttpService {
  final GetStorage _storage = GetStorage();

  String? get accessToken => _storage.read('access_token');

  String? get refreshToken => _storage.read('refresh_token');

  DateTime? get accessTokenExpiry =>
      _storage.read('access_token_expiry') != null
          ? DateTime.parse(_storage.read('access_token_expiry'))
          : null;

  void _logResponse(String method, String url, http.Response response) {
    print("[$method] $url");
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");
  }

/*
  String constructMediaUrl(String relativePath) {
    return '${Endpoint.httpAddress}$relativePath';
  }
*/

  //------------------------------------------------------------------------------Login-----------------------------------------------------------------------------------------------------------
  Future<Map<String, dynamic>> login(String username, String password) async {
    String url = '${Endpoint.httpAddress}/api/v1/login';

    try {
      print("Logging in with username: $username");
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      _logResponse("POST", url, response);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['login_status'] == 'pending') {
          String sessionId = jsonData['session_id'];
          _storage.write('session_id', sessionId);
          return jsonData;
        } else {
          print("Login failed, status: ${jsonData['login_status']}");
        }
      } else {
        print("Login failed, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during login: $e");
    }
    return {};
  }

  Future<bool> verifyOtp(int otp) async {
    String? sessionId = _storage.read('session_id');
    if (sessionId == null) {
      print("Session ID is null, cannot verify OTP.");
      return false;
    }

    String url = '${Endpoint.httpAddress}/api/v1/verify_otp';
    try {
      print("Verifying OTP: $otp with session ID: $sessionId");
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'session_id': sessionId,
          'otp': otp.toString(),
        }),
      );

      _logResponse("POST", url, response);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['login_status'] == 'success') {
          String accessToken = jsonData['access_token'];
          String refreshToken = jsonData['refresh_token'];
          DateTime expiry = DateTime.now().add(Duration(days: 7));
          _storage.write('access_token', accessToken);
          _storage.write('refresh_token', refreshToken);
          _storage.write('access_token_expiry', expiry.toIso8601String());
          print("OTP verified successfully. Access Token: $accessToken");
          return true;
        } else {
          print("OTP verification failed, status: ${jsonData['login_status']}");
        }
      } else {
        print("OTP verification failed, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during OTP verification: $e");
    }
    return false;
  }

  bool isAccessTokenExpired() {
    if (accessTokenExpiry == null) return true;
    return DateTime.now().isAfter(accessTokenExpiry!);
  }

/*
  Future<List<Map<String, dynamic>>> fetchPngAssets() async {
    String? accessToken = _storage.read('access_token');
    if (accessToken == null || accessToken.isEmpty) {
      print("No access token available. Cannot fetch PNG assets.");
      return [];
    }

    if (isAccessTokenExpired()) {
      print("Access token expired. Cannot fetch PNG assets.");
      return [];
    }

    String url = '${Endpoint.httpAddress}/api/v1/cars/';
    try {
      print("Fetching PNG assets from: $url");
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      _logResponse("GET", url, response);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final cars = jsonData['cars'] as List;
        print(
            "PNG assets fetched successfully. Number of cars: ${cars.length}");

        return cars
            .where((car) =>
        car['logo'] != null &&
            car['logo'].toString().endsWith('.png'))
            .map<Map<String, dynamic>>((car) =>
        {
          'text': car['name'],
          'png': constructMediaUrl(car['logo']),
        })
            .toList();
      } else {
        print(
            "Failed to fetch PNG assets, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error while fetching PNG assets: $e");
    }
    return [];
  }

 */

  Future<Map<String, dynamic>> get(String url) async {
    String? accessToken = _storage.read('access_token');
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception("No access token available.");
    }

    try {
      final response = await http.get(
        Uri.parse('${Endpoint.httpAddress}/$url'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      _logResponse("GET", url, response);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error during GET request: $e");
    }
  }

  //-----------------for sub category------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchCategoryDetails(
      int categoryId, bool includeIssues, bool includeRelatedCategories) async {
    String? accessToken = _storage.read('access_token');
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception("No access token is here...");
    }
    String url =
        '${Endpoint.httpAddress}/api/v1/cars/$categoryId/?include_issues=$includeIssues&include_related_categories=$includeRelatedCategories';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      _logResponse("GET", url, response);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("E: fetch category : ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching category ...: $e");
    }
  }


  //----------------------------------for ads---------------------------------------------------------------------------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> fetchAds() async {
    try {
      String url = '${Endpoint.httpAddress}/api/v1/advertisements/';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      _logResponse("GET", url, response);
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else if(response.statusCode == 401) {
        print("E. Error is about login again.");
        throw Exception("Error fetching the ads: ${response.statusCode}");
      }else{
        throw Exception("Error fetching the ads: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching Ads...: $e");
    }
  }
//-----------------------------------------------------------------Section for caching...--------------------------------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> fetchPngAssets() async {
    String? accessToken = _storage.read('access_token');
    if (accessToken == null || accessToken.isEmpty) {
      print("No access token available. Cannot fetch PNG assets.");
      return [];
    }

    if (isAccessTokenExpired()) {
      print("Access token expired. Cannot fetch PNG assets.");
      return [];
    }

    String url = '${Endpoint.httpAddress}/api/v1/cars/';
    try {
      print("Fetching PNG assets from: $url");
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final cars = jsonData['cars'] as List;
        print("PNG assets fetched successfully. Number of cars: ${cars.length}");

        List<Map<String, dynamic>> pngAssets = [];

        for (var car in cars) {
          if (car['logo'] != null && car['logo'].toString().endsWith('.png')) {
            final logoUrl = constructMediaUrl(car['logo']);
            final cachedImagePath = await _downloadAndCacheImage(logoUrl);

            if (cachedImagePath != null) {
              pngAssets.add({
                'id': car['id'],
                'text': car['name'],
                'png': cachedImagePath,
              });
            }
          }
        }

        return pngAssets;
      } else {
        print("Failed to fetch PNG assets, status code: ${response.statusCode}");
        if (response.statusCode == 401) {
          print("Unauthorized: Please check the access token.");
        }
      }
    } catch (e) {
      print("Error while fetching PNG assets: $e");
    }
    return [];
  }

  String constructMediaUrl(String url) {
    return "${Endpoint.httpAddress}/$url";
  }

  Future<String?> _downloadAndCacheImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final dir = Directory('${directory.path}/images');
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }

        final fileName = Uri.parse(url).pathSegments.last;
        final filePath = '${dir.path}/$fileName';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        return filePath;
      } else {
        print("Failed to download image: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error caching image: $e");
    }
    return null;
  }

}
