import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

class AboutAppScreen extends StatelessWidget {
  AboutAppScreen({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeController.isDarkTheme.value
            ? const Color.fromRGBO(44, 45, 49, 1)
            : Colors.white,
        iconTheme: IconThemeData(
          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          "About APP".tr,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            fontFamily: 'Sarbaz',
          ),
        ),
        centerTitle: true,
      ),
      body: Directionality( // Add Directionality widget here to enforce RTL
        textDirection: TextDirection.rtl, // Set text direction to RTL
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 20, 5, 0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  // Information Container
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.redAccent.shade200,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                      child: Column(
                        children: [
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                "Information".tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Application full name".tr, textAlign: TextAlign.right,),
                                    Text(
                                      "ایسیو پارس",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Application version".tr, textAlign: TextAlign.right,),
                                    Text(
                                      "1.0.0",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Category".tr, textAlign: TextAlign.right,),
                                    Text(
                                      "ابزارهای عیب‌یابی ماشین‌آلات سنگین",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Required OS".tr,  textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,),
                                    Text(
                                      "اندروید 5 به بالا",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Support email".tr,
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,),
                                    Text(
                                      "ecupars@gmail.com",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Website".tr, textAlign: TextAlign.right,),
                                    Text(
                                      "ecupars.ir",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Release date".tr, textAlign: TextAlign.right,),
                                    Text(
                                      "اسفند 1403",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),

                  // Description Container
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.cyan,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                "Description".tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "ایسیو پارس یک اپلیکیشن حرفه‌ای برای عیب‌یابی ماشین‌آلات سنگین است که با شعار \"تشخیص دقیق، تعمیر سریع\" طراحی شده است. این برنامه به کاربران کمک می‌کند تا مشکلات فنی ماشین‌آلات را سریع‌تر و دقیق‌تر شناسایی کرده و راه‌حل‌های کاربردی دریافت کنند.",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            softWrap: true,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "ویژگی‌های اصلی:",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            softWrap: true,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "• دسترسی به اطلاعات جامع و دقیق درباره کدهای خطای ماشین‌آلات\n"
                                "• مشاهده نقشه‌ها و دیاگرام‌های سیم‌کشی برای بررسی مشکلات الکتریکی\n"
                                "• ارائه درخت‌های عیب‌یابی جهت تشخیص دقیق‌تر مشکلات\n"
                                "• بخش \"کارشناس شو\" برای کاربران حرفه‌ای‌تر\n"
                                "• راهنمایی جامع برای تعمیر و رفع مشکلات رایج",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            softWrap: true,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "نیاز به اینترنت: این اپلیکیشن برای عملکرد کامل نیاز به اینترنت دارد.",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            softWrap: true,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.orange,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                "Subscription Model".tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "مدل اشتراکی اپلیکیشن:",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            softWrap: true,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "ایسیو پارس دارای نسخه رایگان و اشتراکی است. کاربران می‌توانند به مقالات علمی رایگان دسترسی داشته باشند، اما برخی امکانات حرفه‌ای نیازمند خرید اشتراک هستند.",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            softWrap: true,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "سطوح اشتراک پولی:",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            softWrap: true,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "1. سطح برنزی (پایه):\n"
                                "   • دسترسی به کدهای خطا و توضیحات آن‌ها\n"
                                "   • دریافت پیشنهادات اولیه برای رفع مشکلات\n"
                                "   • اشتراک یک ساله\n"
                                "2. سطح نقره‌ای:\n"
                                "   • دسترسی به تمام امکانات سطح برنزی\n"
                                "   • دسترسی به بخش \"کارشناس شو\"\n"
                                "   • اشتراک یک ساله\n"
                                "   • تمدید سال بعد فقط با هزینه سطح برنزی\n"
                                "3. سطح طلایی:\n"
                                "   • دسترسی به تمام امکانات سطوح قبلی\n"
                                "   • مشاهده جانمایی قطعات ماشین‌آلات\n"
                                "   • دسترسی به دیاگرام‌های سیم‌کشی\n"
                                "   • دسترسی به درخت‌های عیب‌یابی پیشرفته\n"
                                "   • اشتراک یک ساله\n"
                                "   • تمدید سال بعد فقط با هزینه سطح برنزی",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            softWrap: true,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "این اپلیکیشن راهکاری جامع برای تعمیرکاران، رانندگان و کارشناسان حوزه ماشین‌آلات سنگین است تا به سریع‌ترین و دقیق‌ترین شکل ممکن مشکلات فنی را تشخیص داده و برطرف کنند. برای دریافت اطلاعات بیشتر، می‌توانید با پشتیبانی از طریق ایمیل یا شبکه‌های اجتماعی در ارتباط باشید.",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            softWrap: true,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}