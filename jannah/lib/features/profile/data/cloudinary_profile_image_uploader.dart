import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class CloudinaryProfileImageUploader {
  static const _cloudName = 'zfjuqek5';
  // Must match an unsigned upload preset configured in this Cloudinary account.
  static const _uploadPreset = String.fromEnvironment(
    'jannah_profile_images',
    defaultValue: 'jannah_profile_images',
  );

  Future<String> upload({
    required Uint8List imageBytes,
    required String fileName,
  }) async {
    final request =
        http.MultipartRequest(
            'POST',
            Uri.parse(
              'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
            ),
          )
          ..fields['upload_preset'] = _uploadPreset
          ..fields['folder'] = 'profile_images'
          ..files.add(
            http.MultipartFile.fromBytes(
              'file',
              imageBytes,
              filename: fileName.isEmpty ? 'profile_image.jpg' : fileName,
            ),
          );

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 30),
    );
    final response = await http.Response.fromStream(streamedResponse);
    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = responseBody['error'];
      final message = error is Map<String, dynamic>
          ? error['message']
          : 'Image upload failed';

      throw Exception(message);
    }

    final secureUrl = responseBody['secure_url'];

    if (secureUrl is! String || secureUrl.isEmpty) {
      throw Exception('Image upload failed');
    }

    return secureUrl;
  }
}
