import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/auth/SignUpController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/controllers/utills/components/appTheme.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController referrerCodeController = TextEditingController();
  final TextEditingController carBrandController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController phoneControllerStep2 = TextEditingController();
  final TextEditingController phoneControllerStep4 = TextEditingController();

  String? selectedCarBrand;
  List<String> carBrands = [
    'benz'.tr,
    'volvo'.tr,
    'scania'.tr,
    'daf'.tr,
    'man'.tr,
    'renault'.tr,
    'foton'.tr,
    'jac'.tr,
    'iveco'.tr,
    'cummins'.tr,
    'other'.tr
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = 0.70 * screenWidth;
    double spacing = 0.02 * containerWidth;

    List<Widget> steps = [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildHeader(themeController, screenWidth, isFirstStep: true),
          SizedBox(height: screenWidth * 0.09),
          buildTextField(nameController, 'First name'.tr, themeController, containerWidth, TextInputType.text, true),
          SizedBox(height: screenWidth * 0.09),
          buildTextField(surnameController, 'Last name'.tr, themeController, containerWidth, TextInputType.text, true),
          SizedBox(height: screenWidth * 0.09),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildHeader(themeController, screenWidth, isFirstStep: false),
          SizedBox(height: screenWidth * 0.09),
          buildCarBrandDropdown(themeController, containerWidth),
          SizedBox(height: screenWidth * 0.09),
          buildTextField(cityController, 'City (non required)'.tr, themeController, containerWidth, TextInputType.text, false),
          SizedBox(height: screenWidth * 0.09),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildHeader(themeController, screenWidth, isFirstStep: false),
          SizedBox(height: screenWidth * 0.09),
          buildTextField(phoneControllerStep4, 'Confirm Phone Number'.tr, themeController, containerWidth, TextInputType.phone, true),
          SizedBox(height: screenWidth * 0.09),
          buildTextField(referrerCodeController, 'Referrer Code (Optional)'.tr, themeController, containerWidth, TextInputType.text, false),
          SizedBox(height: screenWidth * 0.09),
        ],
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: steps[index],
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(containerWidth - 10, 60),
                elevation: 7,
                shadowColor: Colors.black,
                backgroundColor: Colors.yellow.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              onPressed: () async {
                if (_currentStep < steps.length - 1) {
                  setState(() {
                    _currentStep++;
                  });
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  if (nameController.text.trim().isEmpty ||
                      surnameController.text.trim().isEmpty ||
                      selectedCarBrand == null ||
                      phoneControllerStep4.text.trim().isEmpty) {
                    Get.snackbar("Error".tr, "Please fill all the required fields.".tr);
                    return;
                  }
                  final signUpController = Get.find<SignUpController>();
                  signUpController.nameController.text = nameController.text;
                  signUpController.surnameController.text = surnameController.text;
                  signUpController.carBrandController.text = selectedCarBrand ?? '';
                  signUpController.cityController.text = cityController.text ?? '';
                  signUpController.phoneController.text = phoneControllerStep4.text;
                  signUpController.referrerCodeController.text = referrerCodeController.text;
                  setState(() {
                    _isLoading = true;
                  });
                  await signUpController.sendOtp();
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isLoading
                        ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : Icon(
                      _currentStep < steps.length - 1 ? Icons.arrow_forward : Icons.app_registration,
                      color: Colors.black,
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: Text(
                        _isLoading
                            ? "Loading...".tr
                            : (_currentStep < steps.length - 1 ? "Next".tr : "Sign Up".tr),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Vazir',
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildHeader(ThemeController themeController, double screenWidth, {required bool isFirstStep}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (isFirstStep) {
                Navigator.pop(context);
              } else {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep--;
                  });
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              }
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          SizedBox(width: screenWidth * 0.02),
          Text(
            'Sign Up'.tr,
            style: TextStyle(
              color: themeController.isDarkTheme.value ? AppTheme.nightParsColor : AppTheme.dayParsColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'Sarbaz',
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller,
      String hint,
      ThemeController themeController,
      double width,
      TextInputType keyboardType,
      bool isRequired) {
    return Container(
      width: width,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: isRequired ? "$hint *" : hint,
          hintStyle: TextStyle(
            color: themeController.isDarkTheme.value ? Colors.white : Colors.grey,
            fontFamily: 'Vazir',
            fontSize: 16,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: themeController.isDarkTheme.value ? Colors.white : Colors.grey,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: themeController.isDarkTheme.value ? Colors.white : Colors.grey,
              width: 2,
            ),
          ),
        ),
        style: TextStyle(
          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          fontFamily: 'Vazir',
          fontSize: 16,
        ),
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget buildCarBrandDropdown(ThemeController themeController, double width) {
    return Container(
      width: width,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: 'Car Brand (required)'.tr,
          hintStyle: TextStyle(
            color: themeController.isDarkTheme.value ? Colors.white70 : Colors.black54,
            fontFamily: 'Vazir',
            fontSize: 16,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: themeController.isDarkTheme.value ? Colors.white : Colors.grey,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: themeController.isDarkTheme.value ? Colors.white : Colors.grey,
              width: 2,
            ),
          ),
        ),
        dropdownColor: themeController.isDarkTheme.value ? Colors.black : Colors.white,
        value: selectedCarBrand,
        onChanged: (String? newValue) {
          setState(() {
            selectedCarBrand = newValue;
          });
        },
        items: carBrands.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                fontFamily: 'Vazir',
                fontSize: 16,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    nameController.dispose();
    surnameController.dispose();
    carBrandController.dispose();
    cityController.dispose();
    phoneControllerStep2.dispose();
    phoneControllerStep4.dispose();
    super.dispose();
  }
}
