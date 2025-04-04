import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ZoomableImageMap extends StatelessWidget {
  final String imageUrl;

  const ZoomableImageMap({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.black.withOpacity(0.8),
              insetPadding: const EdgeInsets.all(0),
              child: Stack(
                children: [
                  PhotoView(
                    imageProvider: NetworkImage(imageUrl),
                    backgroundDecoration:
                    BoxDecoration(color: Colors.black.withOpacity(0.8)),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 6.0,
                  ),
                  Positioned(
                    top: 40,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.network(
          imageUrl,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) => const Text(
            'Image failed to load',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
