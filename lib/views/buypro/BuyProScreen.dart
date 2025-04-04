import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/account/AccountController.dart';
import 'package:treenode/controllers/buypro/BuyProController.dart';
import 'package:treenode/views/buypro/components/QrScannerButton.dart';
import 'package:intl/intl.dart';

class BuyProScreen extends StatefulWidget {
  const BuyProScreen({super.key});

  @override
  _BuyProScreenState createState() => _BuyProScreenState();
}

class _BuyProScreenState extends State<BuyProScreen> {
  int _selectedPlanIndex = -1;
  final BuyProController controller = Get.find<BuyProController>();
  bool _showDiscountField = false;
  final TextEditingController _discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 50), () {
      if (!Get.isRegistered<BuyProController>()) {
        Get.lazyPut<BuyProController>(() => BuyProController());
      }
      controller.fetchPlans();
    });

    ever(controller.scannedCode, (code) {
      if (code != null && code
          .toString()
          .isNotEmpty) {
        setState(() {
          _showDiscountField = true;
        });
        _discountController.text = code;
      }
    });
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery
        .of(context)
        .size
        .width;
    double h = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      backgroundColor: const Color(0xFF212025),
      body: Obx(() {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(w * 0.01, w * 0.08, w * 0.02, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close,
                          color: Colors.white.withOpacity(0.3), size: w*0.06),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
                SizedBox(height: h * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "GET  ".tr,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: h*0.04,
                              fontFamily: 'Vazir',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          TextSpan(
                            text: "ACCESS ".tr,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: h*0.04,
                              fontFamily: 'Vazir',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          TextSpan(
                            text: "PRO  ".tr,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 253, 107, 107),
                              fontSize: h*0.04,
                              fontFamily: 'Vazir',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                 SizedBox(height: h * 0.02),
                Column(
                  children: [
                    Padding(
                      padding:  EdgeInsets.fromLTRB(h * 0.02, h * 0.005, h * 0.02, h * 0.005),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                               Icon(Icons.message, color: Colors.yellow,
                                   size: h * 0.04),
                              SizedBox(width: w * 0.04,),
                              Text(
                                "UNLIMITED".tr,
                                style: const TextStyle(
                                    fontFamily: 'Vazir', color: Colors.white),
                              ),
                              SizedBox(width: w * 0.04,),
                              Text(
                                "دسترسی به ده ها هزار کد خطا".tr,
                                style: TextStyle(
                                  fontFamily: 'Vazir',
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                               Icon(Icons.calendar_month_sharp,
                                  color: Colors.greenAccent, size: h * 0.04),
                              SizedBox(width: w * 0.04,),
                              Text(
                                "UNLIMITED".tr,
                                style: const TextStyle(
                                    fontFamily: 'Vazir', color: Colors.white),
                              ),
                              SizedBox(width: w * 0.04,),
                              Text(
                                "دسترسی به درخت های عیب یابی".tr,
                                style: TextStyle(
                                  fontFamily: 'Vazir',
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                               Icon(
                                  Icons.image, color: Colors.lightBlueAccent,
                                   size: h * 0.04),
                              SizedBox(width: w * 0.04,),
                              Text(
                                "UNLIMITED".tr,
                                style: const TextStyle(
                                    fontFamily: 'Vazir', color: Colors.white),
                              ),
                              SizedBox(width: w * 0.04,),
                              Text(
                                "دسترسی به هزاران نقشه".tr,
                                style: TextStyle(
                                  fontFamily: 'Vazir',
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                               Icon(Icons.ramen_dining_sharp,
                                  color: Colors.pinkAccent, size: h * 0.04),
                               SizedBox(width: w * 0.04,),
                              Text(
                                "UNLIMITED".tr,
                                style: const TextStyle(
                                    fontFamily: 'Vazir', color: Colors.white),
                              ),
                              SizedBox(width: w * 0.04,),
                              Text(
                                "دسترسی به بخش کارشناس شو".tr,
                                style: TextStyle(
                                  fontFamily: 'Vazir',
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    Column(
                      children: List.generate(
                        controller.plans.length,
                            (index) {
                          final plan = controller.plans[index];
                          return Column(
                            children: [
                              buildPlanButton(plan, index, h),
                              SizedBox(height: h * 0.02),
                            ],
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Are you have a discount code?".tr,
                            style: const TextStyle(
                              fontFamily: 'Vazir',
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                   //     QRScannerWidget(),
                        IconButton(
                          icon: Icon(
                            _showDiscountField
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _showDiscountField = !_showDiscountField;
                            });
                          },
                        ),
                      ],
                    ),
                    if (_showDiscountField)
                      Padding(
                        padding:  EdgeInsets.symmetric(vertical: w*0.02),
                        child: TextField(
                          controller: _discountController,
                          onChanged: (value) {
                            controller.scannedCode.value = value;
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Enter your discount code".tr,
                            hintStyle: const TextStyle(
                                fontFamily: 'Vazir', color: Colors.white54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              const BorderSide(color: Colors.white70),
                            ),
                          ),
                        ),
                      ),
                    buildSubscribeButton(h),
                    SizedBox(height: h * 0.02),
                    Text(
                      "Your subscription auto-renews weekly unless canceled."
                          .tr,
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Vazir',
                          fontSize: 10,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: h * 0.02),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal:  h * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Terms of use".tr,
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontFamily: 'Vazir',
                                  fontWeight: FontWeight.w400)),
                          Text("Privacy policy".tr,
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontFamily: 'Vazir',
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildPlanButton(Map<String, dynamic> plan, int index, double h) {
    bool selected = _selectedPlanIndex == index;
    final NumberFormat formatter = NumberFormat.decimalPattern('fa');

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlanIndex = index;
        });
      },
      child: Container(
        constraints: BoxConstraints(minHeight: h * 0.06),
        width: double.infinity,
        decoration: BoxDecoration(
          color: selected
              ? const Color.fromARGB(255, 253, 107, 107).withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color.fromARGB(255, 253, 107, 107)
                : Colors.white.withOpacity(0.4),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    plan['name'] ?? 'Plan ${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Vazir',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                  Text(
                    "${formatter.format(plan['price'])} تومان",
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Vazir',
                      fontSize: 16,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                plan['description'] ?? '',
                style: TextStyle(
                  fontFamily: 'Vazir',
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSubscribeButton(double h) {
    final AccountController accountController = Get.find<AccountController>();

    return SizedBox(
      height: h * 0.08,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          Future.delayed(Duration(milliseconds: 100));
          await accountController.getUserProfile();

          if (_selectedPlanIndex < 0) {
            Get.snackbar("Error".tr, "Please select a plan".tr);
            return;
          }

          var selectedPlan = controller.plans[_selectedPlanIndex];
          int planId = selectedPlan['id'];

          String phoneNumber =
              accountController.userProfile['phone_number'] ?? "";
          String email = accountController.userProfile['email'] ?? "";

          if (controller.scannedCode.value.isEmpty) {
            controller.subscribeToPlan(planId, phoneNumber, email);
          } else {
            controller.subscribeToPlan(
              planId,
              phoneNumber,
              email,
              discountCode: controller.scannedCode.value,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 253, 107, 107),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(horizontal: h * 0.045),
        ),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "Subscribe".tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Vazir',
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: h * 0.03,
              ),
            ),
          ],
        ),
      ),
    );
  }
}