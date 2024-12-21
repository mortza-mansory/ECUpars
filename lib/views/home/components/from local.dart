/*  Widget _buildIconAnimations(BuildContext context) {
    double AdaptivePadding(double width) {
      if (width <= 320) {
        return 10;
      } else if (width >= 360) {
        return 20;
      } else if (width >= 400 && width <= 768) {
        return 35;
      } else {
        return 0;
      }
    }

    double c = MediaQuery
        .of(context)
        .size
        .width;
    // double h = MediaQuery.of(context).size.height;
    double hPadding = AdaptivePadding(c);
    double d = 0.260 * c;
    double b = d / 8.5;
    double a = max((c - (3 * d + 2 * b)) / 2, 0);

    double baseHeight = d * 1.41;
    double heightToText = 30.0;

    double T = heightToText / 3;

    double currentHeight = baseHeight;

    double F = 0.23 * currentHeight;

    double containerHeight = baseHeight;

    final apiController = Get.find<ApiController>();
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: a),
        child: Wrap(
          spacing: b,
          runSpacing: 12,
          alignment: WrapAlignment.start,
          children: [
            _buildIconContainer(
                imagePath: apiController.pngAssetsList[0]['png'] ?? '',
                categoryName: apiController.pngAssetsList[0]['text'] ?? '',
                containerColor: const Color.fromARGB(255, 253, 107, 107),
                d: d,
                containerHeight: containerHeight,
                T: T,
                F: F,
                hPadding: hPadding,
                themeController: themeController,
                apiController: apiController,
                index: 0
            ),
            _buildIconContainer(
                imagePath: apiController.pngAssetsList[1]['png'] ?? '',
                categoryName: apiController.pngAssetsList[1]['text'] ?? '',
                containerColor: themeController.isDarkTheme.value
                    ? const Color(0xFF545454)
                    : const Color(0xFFFFF2E2),
                d: d,
                hPadding: hPadding,
                containerHeight: containerHeight,
                T: T,
                F: F,
                themeController: themeController,
                apiController: apiController,
                index: 1
            ),
            _buildIconContainer(
                imagePath: apiController.pngAssetsList[2]['png'] ?? '',
                categoryName: apiController.pngAssetsList[2]['text'] ?? '',
                containerColor: themeController.isDarkTheme.value
                    ? const Color(0xFF545454)
                    : const Color(0xFFFFF2E2),
                d: d,
                hPadding: hPadding,
                containerHeight: containerHeight,
                T: T,
                F: F,
                themeController: themeController,
                apiController: apiController,
                index: 2
            ),
            _buildIconContainer(
                imagePath: apiController.pngAssetsList[3]['png'] ?? '',
                categoryName: apiController.pngAssetsList[3]['text'] ?? '',
                containerColor: themeController.isDarkTheme.value
                    ? const Color(0xFF545454)
                    : const Color(0xFFFFF2E2),
                d: d,
                hPadding: hPadding,
                containerHeight: containerHeight,
                T: T,
                F: F,
                themeController: themeController,
                apiController: apiController,
                index: 3
            ),
            _buildIconContainer(
                imagePath: apiController.pngAssetsList[4]['png'] ?? '',
                categoryName: apiController.pngAssetsList[4]['text'] ?? '',
                containerColor: themeController.isDarkTheme.value
                    ? const Color(0xFF545454)
                    : const Color(0xFFFFF2E2),
                d: d,
                hPadding: hPadding,
                containerHeight: containerHeight,
                T: T,
                F: F,
                themeController: themeController,
                apiController: apiController,
                index: 4
            ),
            _buildIconContainer(
                imagePath: apiController.pngAssetsList[5]['png'] ?? '',
                categoryName: apiController.pngAssetsList[5]['text'] ?? '',
                containerColor: themeController.isDarkTheme.value
                    ? const Color(0xFF545454)
                    : const Color(0xFFFFF2E2),
                d: d,
                hPadding: hPadding,
                containerHeight: containerHeight,
                T: T,
                F: F,
                themeController: themeController,
                apiController: apiController,
                index: 5
            ),
            _buildIconContainer(
                imagePath: apiController.pngAssetsList[6]['png'] ?? '',
                categoryName: apiController.pngAssetsList[6]['text'] ?? '',
                containerColor: themeController.isDarkTheme.value
                    ? const Color(0xFF545454)
                    : const Color(0xFFFFF2E2),
                d: d,
                hPadding: hPadding,
                containerHeight: containerHeight,
                T: T,
                F: F,
                themeController: themeController,
                apiController: apiController,
                index: 6
            ),
            _buildIconContainer(
                imagePath: apiController.pngAssetsList[7]['png'] ?? '',
                categoryName: apiController.pngAssetsList[7]['text'] ?? '',
                containerColor: themeController.isDarkTheme.value
                    ? const Color(0xFF545454)
                    : const Color(0xFFFFF2E2),
                d: d,
                hPadding: hPadding,
                containerHeight: containerHeight,
                T: T,
                F: F,
                themeController: themeController,
                apiController: apiController,
                index: 7
            ),
            _buildIconContainer(
                imagePath: apiController.pngAssetsList[8]['png'] ?? '',
                categoryName: apiController.pngAssetsList[8]['text'] ?? '',
                containerColor: themeController.isDarkTheme.value
                    ? const Color(0xFF545454)
                    : const Color(0xFFFFF2E2),
                d: d,
                hPadding: hPadding,
                containerHeight: containerHeight,
                T: T,
                F: F,
                themeController: themeController,
                apiController: apiController,
                index: 8
            ),
            _buildIconContainer(
                imagePath: apiController.pngAssetsList[9]['png'] ?? '',
                categoryName: apiController.pngAssetsList[9]['text'] ?? '',
                containerColor: themeController.isDarkTheme.value
                    ? const Color(0xFF545454)
                    : const Color(0xFFFFF2E2),
                d: d,
                hPadding: hPadding,
                containerHeight: containerHeight,
                T: T,
                F: F,
                themeController: themeController,
                apiController: apiController,
                index: 9
            ),
            _buildIconContainer(
                imagePath: apiController.pngAssetsList[10]['png'] ?? '',
                categoryName: apiController.pngAssetsList[10]['text'] ?? '',
                containerColor: themeController.isDarkTheme.value
                    ? const Color(0xFF545454)
                    : const Color(0xFFFFF2E2),
                d: d,
                hPadding: hPadding,
                containerHeight: containerHeight,
                T: T,
                F: F,
                themeController: themeController,
                apiController: apiController,
                index: 10
            ),
            _buildIconContainer(
                imagePath: apiController.pngAssetsList[11]['png'] ?? '',
                categoryName: apiController.pngAssetsList[11]['text'] ?? '',
                containerColor: themeController.isDarkTheme.value
                    ? const Color(0xFF545454)
                    : const Color(0xFFFFF2E2),
                d: d,
                hPadding: hPadding,
                containerHeight: containerHeight,
                T: T,
                F: F,
                themeController: themeController,
                apiController: apiController,
                index: 11
            ),
          ],
        ),
      );
    });
  }

  Widget _buildIconContainer({
    required double hPadding,
    required String imagePath,
    required String categoryName,
    required Color containerColor,
    required double d,
    required double containerHeight,
    required double T,
    required double F,
    required ThemeController themeController,
    required ApiController apiController,
    required int index,
  }) {
  */