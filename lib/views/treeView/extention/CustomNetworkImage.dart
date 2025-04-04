import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;

  const CustomNetworkImage({
    Key? key,
    required this.imageUrl,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String src = imageUrl;
    if (!src.startsWith('http')) {
      src = 'https://django-noxeas.chbk.app$src';
    }

    return GestureDetector(
      onTap: () => _showFocusMode(context, src),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: width != null
            ? SizedBox(
          width: width,
          child: Image.network(
            src,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return Text('Failed to load image: $src');
            },
          ),
        )
            : Image.network(
          src,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return Text('Failed to load image: $src');
          },
        ),
      ),
    );
  }

  void _showFocusMode(BuildContext context, String imageUrl) {
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
                backgroundDecoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 6.0,
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
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
  }
}