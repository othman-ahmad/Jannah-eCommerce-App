import 'dart:typed_data';

import 'package:flutter/material.dart';

class EditableProfileAvatar extends StatelessWidget {
  final Uint8List? imageBytes;
  final String? imageUrl;
  final bool isUploading;
  final VoidCallback? onTap;

  const EditableProfileAvatar({
    required this.imageBytes,
    required this.imageUrl,
    required this.isUploading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasNetworkImage = imageUrl?.isNotEmpty ?? false;

    return Semantics(
      button: true,
      label: 'Change profile image',
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          height: 104,
          width: 104,
          child: Stack(
            children: [
              Positioned.fill(
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: ClipOval(
                    child: SizedBox.expand(
                      child: imageBytes != null
                          ? Image.memory(imageBytes!, fit: BoxFit.cover)
                          : hasNetworkImage
                          ? Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                    size: 42,
                                  ),
                            )
                          : const Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 42,
                            ),
                    ),
                  ),
                ),
              ),
              if (isUploading)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: SizedBox(
                        height: 26,
                        width: 26,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 4,
                bottom: 4,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: onTap == null ? Colors.grey.shade700 : Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
