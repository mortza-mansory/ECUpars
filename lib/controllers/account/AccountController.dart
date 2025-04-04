import 'package:get/get.dart';
import 'package:treenode/services/api/HttpService.dart';

class AccountController extends GetxController {
  var userProfile = {}.obs;
  var referralCode = "".obs;
  var discountCodeDetail = {}.obs;
  var isLoading = false.obs;
  var subscriptionInfo = RxMap<String, dynamic>({});
  var referredUsers = <Map<String, dynamic>>[].obs;
  var showBuyPro = false.obs;

  final HttpService _httpService = HttpService();

  @override
  void onInit() {
    super.onInit();
    Init();
  }

  Future<void> Init() async {
    await getUserProfile();
    await fetchDiscountCodeDetail();
    await fetchSubscriptionDetails();
    await fetchReferralCode();
  }

  bool _shouldShowBuyPro(dynamic subscription) {
    if (subscription == null) return true;
    if (subscription is List) {
      return subscription.isEmpty;
    }
    if (subscription is Map<String, dynamic>) {
      if (subscription.isEmpty) return true;
      if (subscription["is_active"] == false) return true;
      if (subscription["plan"] != null &&
          subscription["plan"]["price"] != null &&
          subscription["plan"]["price"].toString() == "0") {
        return true;
      }
    }
    return false;
  }

  Future<void> fetchSubscriptionDetails() async {
    try {
      if (userProfile.value.isEmpty) {
        userProfile.value = await _httpService.fetchUserProfile();
      }
      subscriptionInfo.value = userProfile.value['subscription'] ?? {};
      showBuyPro.value = _shouldShowBuyPro(subscriptionInfo.value);
    } catch (e) {
      print("Error fetching subscription details: $e");
    }
  }

  Future<void> getUserProfile() async {
    isLoading.value = true;
    try {
      userProfile.value = await _httpService.fetchUserProfile();
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReferralCode() async {
    try {
      var userId = userProfile.value['user_id'];
      if (userId == null) {
        print("User ID is null. Cannot fetch referral code.");
        return;
      }
      var data = await _httpService.fetchReferralCodeDetail(userId);
      referralCode.value = data['referral_code'] ?? "";
      referredUsers.value = List<Map<String, dynamic>>.from(data['referred_users'] ?? []);
    } catch (e) {
      print("Error fetching referral code: $e");
    }
  }
  Future<void> fetchDiscountCodeDetail() async {
    try {
      var userId = userProfile.value['user_id'];
      if (userId == null) {
        print("User ID is null");
        return;
      }
      var data = await _httpService.fetchDiscountCodeDetail(userId);
      if (data["discount_codes"] != null && data["discount_codes"].isNotEmpty) {
        discountCodeDetail.value = data["discount_codes"][0];
        referredUsers.value = List<Map<String, dynamic>>.from(
            discountCodeDetail.value['users_with_discount'] ?? []);
      } else {
        discountCodeDetail.value = {};
        referredUsers.value = [];
      }
    } catch (e) {
      if (e.toString().contains("failed to fetch discount code: 404")) {
        Get.snackbar(
          "No Discount Code".tr,
          "You dont have a discount code.".tr,
          snackPosition: SnackPosition.TOP,
        );
      }
      print("Error fetching discount code details: $e");
    }
  }

  int get totalSubscriptionDays {
    if (subscriptionInfo.isEmpty ||
        subscriptionInfo['start_date'] == null ||
        subscriptionInfo['end_date'] == null) return 0;
    DateTime startDate = DateTime.parse(subscriptionInfo['start_date']);
    DateTime endDate = DateTime.parse(subscriptionInfo['end_date']);
    return endDate.difference(startDate).inDays;
  }

  int get remainingSubscriptionDays {
    if (subscriptionInfo.isEmpty || subscriptionInfo['end_date'] == null) return 0;
    DateTime endDate = DateTime.parse(subscriptionInfo['end_date']);
    int days = endDate.difference(DateTime.now().toUtc()).inDays;
    print(days);
    return days < 0 ? 0 : days;
  }

  double get subscriptionProgress {
    int total = totalSubscriptionDays;
    if (total == 0) return 0;
    double progress = remainingSubscriptionDays / total;
    return progress.clamp(0.0, 1.0);
  }
}