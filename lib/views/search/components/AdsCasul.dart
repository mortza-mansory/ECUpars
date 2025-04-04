import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:treenode/controllers/api/ApiAds.dart';

class AdsCarousel extends StatefulWidget {
  const AdsCarousel({Key? key}) : super(key: key);

  @override
  _AdsCarouselState createState() => _AdsCarouselState();
}

String decodeUnicode(String input) {
  Map<String, dynamic> tempMap = {"key": input};
  Map<String, dynamic> decodedMap = tempMap.map((key, value) {
    if (value is String) {
      return MapEntry(key, utf8.decode(value.runes.toList(), allowMalformed: true));
    } else {
      return MapEntry(key, value);
    }
  });
  return decodedMap["key"];
}

class _AdsCarouselState extends State<AdsCarousel> {
  final ApiAds adsController = Get.find<ApiAds>();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Load ads if not loaded
    adsController.loadADS();

    // Auto-scroll every 4 seconds
    _timer = Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (adsController.GatheredAds.isNotEmpty && _pageController.hasClients) {
        _currentPage = (_currentPage + 1) % adsController.GatheredAds.length;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Using the same height as your original ad: MediaQuery.of(context).size.height / 3.5
    final double adHeight = MediaQuery.of(context).size.height / 3.5;
    return Obx(() {
      if (adsController.GatheredAds.isEmpty) {
        return SizedBox(
          height: adHeight,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: adHeight,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: adsController.GatheredAds.length,
              itemBuilder: (context, index) {
                final ad = adsController.GatheredAds[index];
                return GestureDetector(
                  onTap: () async {
                    final Uri uri = Uri.parse(ad['link'] ?? '');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: adHeight,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(ad['banner'] ?? ''),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        width: double.infinity,
                        height: adHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      // Title positioned at bottom-right
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: Text(
                          decodeUnicode(ad['title'] ?? ''),
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            adsController.GatheredAds.length,
                                (dotIndex) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              width: _currentPage == dotIndex ? 12 : 8,
                              height: _currentPage == dotIndex ? 12 : 8,
                              decoration: BoxDecoration(
                                color: _currentPage == dotIndex ? Colors.white : Colors.white54,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
