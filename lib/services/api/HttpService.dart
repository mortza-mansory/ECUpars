import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:treenode/controllers/hardware/HardwareController.dart';
import 'config/endpoint.dart';

class HttpService {
  final GetStorage _storage = GetStorage();

  // String? hardwareId = Get.find<HardwareController>().deviceId;

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
  String decodeUtf8String(String encoded) {
    try {
      final unescaped = encoded.replaceAllMapped(
          RegExp(r'\\u([0-9a-fA-F]{4})'),
              (match) => String.fromCharCode(int.parse(match[1]!, radix: 16)));
      return utf8.decode(unescaped.codeUnits, allowMalformed: true);
    } catch (e) {
      return encoded;
    }
  }

  Future<http.Response> _getWithRefresh(String url,
      {Map<String, String>? headers}) async {
    String? token = _storage.read('access_token');
    if (token == null || token.isEmpty) {
      if (!await refreshAccessToken()) {
        throw Exception("No access token available and refresh failed.");
      }
      token = _storage.read('access_token');
    }

    headers = (headers ?? {})
      ..addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

    http.Response response = await http.get(Uri.parse(url), headers: headers);
    _logResponse("GET", url, response);
    print(headers);

    if (response.statusCode == 401) {
      try {
        final bodyJson = jsonDecode(response.body);
        if (bodyJson is Map && bodyJson['code'] == 'token_not_valid') {
          if (await refreshAccessToken()) {
            token = _storage.read('access_token');
            headers['Authorization'] = 'Bearer $token';
            response = await http.get(Uri.parse(url), headers: headers);
            _logResponse("GET Retry", url, response);
          }
        }
      } catch (e) {
        if (await refreshAccessToken()) {
          token = _storage.read('access_token');
          headers['Authorization'] = 'Bearer $token';
          response = await http.get(Uri.parse(url), headers: headers);
          _logResponse("GET Retry", url, response);
        }
      }
    }

    return response;
  }

  //------------------------------------------------------------------------------Login-----------------------------------------------------------------------------------------------------------
  Future<Map<String, dynamic>> login(String username, String password) async {
    String url = '${Endpoint.httpAddress}/api/v1/login';
    String? hardwareId = Get.find<HardwareController>().deviceId;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "X-Device-ID": hardwareId ?? "",
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      _logResponse("POST", url, response);

      String responseBody = utf8.decode(response.bodyBytes, allowMalformed: true);
      Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        return jsonResponse;
      } else if (response.statusCode == 400 || response.statusCode == 403) {
        return jsonResponse;
      } else {
        return {'error': 'Unexpected error occurred. Please try again later.'};
      }
    } catch (e) {
      return {'error': 'Network error. Please check your connection.'};
    }
  }
  Future<bool> verifyOtp(int otp) async {
    String? sessionId = _storage.read('session_id');
    if (sessionId == null) {
      throw Exception("Session ID not found.");
    }

    String url = '${Endpoint.httpAddress}/api/v1/verify_otp';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'session_id': sessionId, 'otp': otp.toString()}),
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
          return true;
        } else {
          throw Exception(jsonData['error'] ?? 'OTP verification failed.');
        }
      } else {
        final jsonData = jsonDecode(response.body);
        throw Exception(jsonData['error'] ?? 'Invalid OTP or server error (Status: ${response.statusCode}).');
      }
    } catch (e) {
      rethrow;
    }
  }

  //----------------------------------------------------Access token validation-----------------------------------------------------------------
  Future<bool> isAccessTokenExpired() async {
    String? token = _storage.read('access_token');

    if (token == null || token.isEmpty) {
      return true;
    }
    String url = '${Endpoint.httpAddress}/api/v1/cars/';
    try {
      final response = await _getWithRefresh(url);
      if (response.statusCode == 200) {
        return false;
      } else if (response.statusCode == 401) {
        await _clearAccessToken();
        return !(await refreshAccessToken());
      } else {
        return true;
      }
    } catch (e) {
      return true;
    }
  }

  bool isAccessTokenExpiredSync() {
    String? token = _storage.read('access_token');

    if (token == null || token.isEmpty) {
      return true;
    }

    if (accessTokenExpiry == null) {
      return true;
    }

    return DateTime.now().isAfter(accessTokenExpiry!);
  }

  Future<void> _clearAccessToken() async {
    await _storage.remove('access_token');
  }

  //----------------------------Refresh token--------------------------------------------------------------------------------
  Future<bool> refreshAccessToken() async {
    String? storedRefreshToken = _storage.read('refresh_token');
    if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
      return false;
    }

    String url = '${Endpoint.httpAddress}/api/v1/token/refresh/';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': storedRefreshToken}),
      );

      _logResponse("POST", url, response);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('access')) {
          String newAccessToken = jsonData['access'];
          _storage.write('access_token', newAccessToken);
          _storage.write('access_token_expiry',
              DateTime.now().add(Duration(hours: 72)).toIso8601String());
          return true;
        } else {}
      } else {}
    } catch (e) {}
    return false;
  }

  //----------------------------Generic GET url--------------------------------------------------------------------------------
  Future<Map<String, dynamic>> get(String url) async {
    String fullUrl = '${Endpoint.httpAddress}/$url';
    final response = await _getWithRefresh(fullUrl);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized request: Refresh token failed.");
    }
    throw Exception("Failed to fetch data: ${response.statusCode}");
  }

  //-----------------for sub category------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchCategoryDetails(
      int categoryId, bool includeIssues, bool includeRelatedCategories) async {
    String url =
        '${Endpoint.httpAddress}/api/v1/cars/$categoryId/?include_issues=$includeIssues&include_related_categories=$includeRelatedCategories&include_articles=true&include_maps=true';

    String? hardwareId = Get.find<HardwareController>().deviceId;
    String? accessToken = Get.find<HttpService>().accessToken;

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception("No access token available.");
    }

    final headers = {
      "Content-Type": "application/json",
      "X-Device-ID": hardwareId ?? "",
      "Authorization": "Bearer $accessToken"
    };

    try {
      final response =
          await Get.find<HttpService>()._getWithRefresh(url, headers: headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            "Fetch category failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Fetch category exception: $e");
    }
  }

  //----------------------------------for issues---------------------------------------------------------------------------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchIssueDetails(int issueId) async {
    String url = '${Endpoint.httpAddress}/api/v1/issues/$issueId/';

    String? hardwareId = Get.find<HardwareController>().deviceId;
    String? accessToken = Get.find<HttpService>().accessToken;

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception("No access token available.");
    }
//hardwareId
    final headers = {
      "Content-Type": "application/json",
      "X-Device-ID": hardwareId ?? "",
      "Authorization": "Bearer $accessToken"
    };

    try {
      final response = await _getWithRefresh(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("E: fetch issue : ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("E: fetch issue exception: $e");
    }
  }

  //----------------------------------for steps--------------------------------------------------------------------------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchStepDetail(int stepId) async {
    String url = '${Endpoint.httpAddress}/api/v1/steps/$stepId/';
    String? hardwareId = Get.find<HardwareController>().deviceId;
    String? accessToken = Get.find<HttpService>().accessToken;

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception("No access token available.");
    }

    final headers = {
      "Content-Type": "application/json",
      "X-Device-ID": hardwareId ?? "",
      "Authorization": "Bearer $accessToken"
    };

    try {
      final response = await Get.find<HttpService>()._getWithRefresh(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // Decode UTF-8 error response
        Map<String, dynamic> errorResponse = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(errorResponse['detail'] ?? "Unknown error");
      }
    } catch (e) {
      throw Exception("E: fetch step exception: $e");
    }
  }

  //----------------------------------for ads---------------------------------------------------------------------------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> fetchAds() async {
    String url = '${Endpoint.httpAddress}/api/v1/advertisements/';
    final response = await _getWithRefresh(url);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized: Token refresh failed.");
    } else {
      throw Exception("Error fetching the ads: ${response.statusCode}");
    }
  }

  //-----------------------------------------------------------------Section for caching...--------------------------------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> fetchPngAssets() async {
    String url = '${Endpoint.httpAddress}/api/v1/cars/';
    final response = await _getWithRefresh(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final cars = jsonData['cars'] as List;

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
              'order': car['order'] ?? 9999,
            });
          }
        }
      }
      return pngAssets;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized: Token refresh failed.");
    } else {
      return [];
    }
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
        return null;
      }
    } catch (e) {}
    return null;
  }

  //-----------------------------------Searching Section-----------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> fetchSearchResults({
    required String query,
    required List<String> filterOptions,
    List<int>? categoryIds,
    List<int>? subcategoryIds,
  }) async {
    String baseUrl = '${Endpoint.httpAddress}/api/v1/search/';

    List<String> queryParams = [
      'query=${Uri.encodeQueryComponent(query)}',
    ];

    if (categoryIds != null && categoryIds.isNotEmpty) {
      queryParams.addAll(categoryIds.map((id) => 'category_id=$id'));
    }

    if (subcategoryIds != null && subcategoryIds.isNotEmpty) {
      queryParams.addAll(subcategoryIds.map((id) => 'category_id=$id'));
    }

    String url = '$baseUrl?${queryParams.join('&')}';

    String? hardwareId = Get.find<HardwareController>().deviceId;

    final headers = <String, String>{"Content-Type": "application/json"};
    if (hardwareId != null) {
      headers["hardware_id"] = hardwareId;
    }
    try {
      final response = await _getWithRefresh(url, headers: headers);
      if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(jsonData['results']);
      } else {
        throw Exception("Request failed: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error during search: $e");
    }
  }

  //--------Articles-----------------------------------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> fetchArticles() async {
    String url = '${Endpoint.httpAddress}/api/v1/articles/';

    String? hardwareId = Get.find<HardwareController>().deviceId;

    final headers = <String, String>{"Content-Type": "application/json"};
    if (hardwareId != null) {
      headers["hardware_id"] = hardwareId;
    }

    final response = await _getWithRefresh(url, headers: headers);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List articles = jsonData['results'];
      return articles.cast<Map<String, dynamic>>();
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized: Token refresh failed.");
    } else {}
    return [];
  }

  Future<Map<String, dynamic>> fetchArticleById(int articleId) async {
    String url = '${Endpoint.httpAddress}/api/v1/articles/$articleId/';
    String? hardwareId = Get.find<HardwareController>().deviceId;

    final headers = <String, String>{
      "Content-Type": "application/json",
    };
    if (hardwareId != null) {
      headers["hardware_id"] = hardwareId;
    }

    final response = await _getWithRefresh(url, headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return jsonData;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized: Token refresh failed.");
    } else if (response.statusCode == 403) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['detail'] ?? "Access denied.");
    } else {
      throw Exception(
          "Failed to fetch article, status code: ${response.statusCode}");
    }
  }

  //-------- Subscription Plans --------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> fetchSubscriptionPlans() async {
    String url = '${Endpoint.httpAddress}/api/v1/subscription-plans/';
    final response = await _getWithRefresh(url);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception(
          "Failed to fetch subscription plans: ${response.statusCode}");
    }
  }

  //-------- Request Payment ----------------------------------------------------------
  Future<Map<String, dynamic>> requestPayment({
    required int planId,
    required String userPhone,
    required String userEmail,
    String? discountCode,
  }) async {
    String url = '${Endpoint.httpAddress}/api/v1/payment/request/';

    String? token = _storage.read('access_token');
    if (token == null || token.isEmpty) {
      if (!await refreshAccessToken()) {
        throw Exception("No access token available and refresh failed.");
      }
      token = _storage.read('access_token');
    }
    String? hardwareId = Get.find<HardwareController>().deviceId;

    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (hardwareId != null) 'X-Device-ID': hardwareId,
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final body = {
      'plan_id': planId,
      'user_phone': userPhone,
      'user_email': userEmail,
      if (discountCode != null && discountCode.isNotEmpty)
        'discount_code': discountCode,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    _logResponse("POST", url, response);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Failed to request payment: ${response.statusCode} - ${response.body}");
    }
  }

  Future<Map<String, dynamic>> checkPaymentStatus(int paymentId) async {
    String url =
        '${Endpoint.httpAddress}/api/v1/payment/status/?payment_id=$paymentId';
    final response = await _getWithRefresh(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to check payment status: ${response.statusCode}");
    }
  }

  //----------SignUp----------------------------------------------------
  String decode(String rawResponse) {
    List<int> responseBytes = rawResponse.codeUnits;
    String decoded = utf8.decode(responseBytes, allowMalformed: true);
    return decoded;
  }

  Future<Map<String, dynamic>> sendOtp({
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required String carBrand,
    required String city,
    required String hardwareId,
    String? referrerCode,
  }) async {
    final url = Uri.parse('${Endpoint.httpAddress}/api/v1/send-otp/');
    final body = jsonEncode({
      "phone_number": phoneNumber,
      "first_name": firstName,
      "last_name": lastName,
      "car_brand": carBrand,
      "city": city,
      "hardware_id": hardwareId,
      "referrer_code": referrerCode,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 400) {
        Get.snackbar(
            "Error".tr,
            "حساب کاربری شما قبلاً ایجاد شده است. لطفاً برای ادامه، از گزینه 'ورود' استفاده کنید."
                .tr,
            snackPosition: SnackPosition.BOTTOM);
        throw Exception('User already registered');
      } else {
        throw Exception('Failed to send OTP');
      }
    } catch (e) {
      throw Exception('Error: \$e');
    }
  }

  Future<bool> verifyOtpAndSignup({
    required String phoneNumber,
    required String otp,
    required String password,
  }) async {
    print('Starting verifyOtpAndSignup with phone: $phoneNumber, otp: $otp');
    final url = Uri.parse('${Endpoint.httpAddress}/api/v1/verify-otp-and-signup/');
    final body = jsonEncode({
      "phone_number": phoneNumber,
      "otp": otp,
      "password": password,
    });

    try {
      print('Sending POST request to $url with body: $body');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print('Response received: statusCode = ${response.statusCode}, body = ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('JSON data decoded: $jsonData');

        String accessToken = jsonData['access_token'];
        String refreshToken = jsonData['refresh_token'];
        DateTime expiry = DateTime.now().add(Duration(days: 7));

        print('Storing tokens: access_token = $accessToken, refresh_token = $refreshToken');
        _storage.write('access_token', accessToken);
        _storage.write('refresh_token', refreshToken);
        _storage.write('access_token_expiry', expiry.toIso8601String());

        print('verifyOtpAndSignup successful, returning true');
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in verifyOtpAndSignup: $e');
    }
    print('verifyOtpAndSignup failed, returning false');
    return false;
  }

  Future<void> resendOtp(String phoneNumber) async {
    final String url = "${Endpoint.httpAddress}/api/v1/resend-otp/";
    try {
      const String requestType = "signup";
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phone_number": phoneNumber,
          "request_type": requestType,
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception("Authentication credentials were not provided.");
      } else if (response.statusCode == 403) {
        throw Exception("Access forbidden: Check token and permissions.");
      } else if (response.statusCode == 404) {
        throw Exception("User not found.");
      } else {
        throw Exception("Failed to fetch user profile: ${response.statusCode}");
      }
    } catch (e) {
    }
  }
  Future<Map<String, dynamic>> resendOtpForLogin(String username, String password) async {
    final String url = "${Endpoint.httpAddress}/api/v1/resend-otp/";
    const String requestType = "login";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
          "request_type": requestType,
        }),
      );
      print(response.body);
      print(response.statusCode);

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
     print(response.body);
      if (response.statusCode == 200) {
        return responseBody;
      } else {
        final errorMessage = responseBody['error'] ?? responseBody['message'] ?? 'Unknown error';
        throw Exception(decodeUtf8String(errorMessage));
      }
    } catch (e) {
      throw Exception("Error resending OTP for login: $e");
    }
  }

//----------Profile----------------------------------------------------
  Future<Map<String, dynamic>> fetchUserProfile() async {
    String? token = _storage.read('access_token');

    if (token == null || token.isEmpty) {
      throw Exception("No access token available. Please log in again.");
    }

    String url = '${Endpoint.httpAddress}/api/v1/user-profile/';
    final response = await _getWithRefresh(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception("Authentication credentials were not provided.");
    } else if (response.statusCode == 403) {
      throw Exception("Access forbidden: Check token and permissions.");
    } else if (response.statusCode == 404) {
      throw Exception("User not found.");
    } else {
      throw Exception("Failed to fetch user profile: ${response.statusCode}");
    }
  }

//-------Referral seciton----------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchReferralCodeDetail(int userId) async {
    String url = '${Endpoint.httpAddress}/api/v1/referral/$userId';
    final response = await _getWithRefresh(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("failed to fetch referral code: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> fetchDiscountCodeDetail(int userId) async {
    String url = '${Endpoint.httpAddress}/api/v1/discount-codes/$userId';
    final response = await _getWithRefresh(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception("failed to fetch discount code: 404");
    } else {
      throw Exception("failed to fetch discount code: ${response.statusCode}");
    }
  }
}
