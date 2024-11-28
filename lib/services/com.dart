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
/*
  Future<bool> refreshToken() async {
    return await httpService.refreshAccessToken();
  }
 */
}


