import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CloudinaryImage extends StatelessWidget {
  const CloudinaryImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  /// Relative path in Cloudinary.
  /// Example: "assets/icons/logo.png"
  final String imagePath;

  final double? width;
  final double? height;
  final BoxFit fit;

  static const String _baseUrl =
      'https://res.cloudinary.com/zfjuqek5/image/upload/f_auto,q_auto';

  @override
  Widget build(BuildContext context) {
    final imageUrl = imagePath.startsWith('http')
        ? imagePath
        : '$_baseUrl/$imagePath';

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, __) => const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
    );
  }
}
