import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
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

  String constructMediaUrl(String relativePath) {
    return '${Endpoint.httpAddress}$relativePath';
  }

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
}
