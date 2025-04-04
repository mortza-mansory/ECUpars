import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

class PrivacyScreen extends StatelessWidget {
  final String privacyPolicyText = '''
حریم خصوصی کاربران

آخرین بروزرسانی: 1403/12/15

این سیاست حریم خصوصی توضیح می‌دهد که چگونه اپلیکیشن ما اطلاعات کاربران را جمع‌آوری، استفاده و محافظت می‌کند. با استفاده از این اپلیکیشن، شما موافقت خود را با شرایط زیر اعلام می‌کنید.

 1. جمع‌آوری اطلاعات
ما اطلاعات زیر را از کاربران جمع‌آوری می‌کنیم:
- اطلاعات شخصی: نام و شماره تلفن جهت احراز هویت و خرید اشتراک.
- شناسه دستگاه (ID DEVICE): به‌منظور مدیریت دسترسی کاربران.

 2. استفاده از اطلاعات
اطلاعات جمع‌آوری‌شده برای اهداف زیر استفاده می‌شود:
- احراز هویت کاربران برای خرید اشتراک و استفاده از خدمات.
- مدیریت اشتراک و ارائه خدمات مرتبط با حساب کاربری.
- حفظ امنیت حساب‌های کاربران.

 3. اشتراک‌گذاری اطلاعات با اشخاص ثالث
ما اطلاعات کاربران را با هیچ شرکت، سازمان یا شخص ثالثی به اشتراک نمی‌گذاریم.

 4. ذخیره‌سازی و امنیت اطلاعات
- اطلاعات کاربران تنها تا زمانی که اشتراک فعال دارند**، ذخیره خواهد شد.
- ما از روش‌های امنیتی مناسب، از جمله **رمزگذاری داده‌ها**، برای محافظت از اطلاعات کاربران استفاده می‌کنیم.

 5. حقوق کاربران
کاربران این حق را دارند که:
- اطلاعات شخصی خود را اصلاح یا حذف کنند.
- درخواست حذف کامل حساب کاربری و داده‌های مرتبط خود را ارائه دهند.

6. مکانیزم‌های حذف اطلاعات
کاربران می‌توانند از طریق تنظیمات اپلیکیشن یا تماس با پشتیبانی، درخواست حذف اطلاعات خود را ارسال کنند.

7. استفاده از کوکی‌ها و ابزارهای تحلیلی
این اپلیکیشن **از هیچ‌گونه کوکی (Cookies) یا ابزارهای تحلیلی مانند Google Analytics استفاده نمی‌کند.

 8. دسترسی‌های موردنیاز اپلیکیشن
این اپلیکیشن هیچ‌گونه دسترسی خاصی (مانند دوربین، میکروفون، موقعیت مکانی یا حافظه) از کاربران درخواست نمی‌کند.

 9. تغییرات در سیاست حریم خصوصی
در صورت تغییر سیاست‌های حریم خصوصی، کاربران از طریق نوتیفیکیشن درون‌برنامه‌ای یا پیامک مطلع خواهند شد.

 10. راه‌های ارتباطی
در صورت وجود هرگونه سؤال درباره حریم خصوصی، کاربران می‌توانند از طریق ایمیل و شبکه‌های اجتماعی با پشتیبانی اپلیکیشن در تماس باشند.

این سیاست با هدف احترام به حقوق کاربران و محافظت از اطلاعات آن‌ها تنظیم شده است. لطفاً در صورت داشتن هرگونه سؤال، با ما در ارتباط باشید.
  ''';
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: themeController.isDarkTheme.value
            ? Color.fromRGBO(44, 45, 49, 1)
            : Color.fromRGBO(255, 255, 255, 1.0),
        iconTheme: IconThemeData(
          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Private Policy".tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: "Sarbaz",
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            child: Text(
              privacyPolicyText,
              style: TextStyle(fontSize: 14.0,
                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                fontFamily: 'Vazir',
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,

            ),
          ),
        ),
      ),
    );
  }
}