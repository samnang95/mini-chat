import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';
import 'package:mini_chat/app/config/env_config.dart';

class StorageService extends GetxService {
  final ImagePicker _picker = ImagePicker();
  final Dio _dio = Dio();

  static const String _uploadUrl = 'https://upload.imagekit.io/api/v1/files/upload';

  // ── Pick Image from Gallery or Camera ──────────────────
  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (image == null) return null;
    return File(image.path);
  }

  // ── Upload Avatar to ImageKit.io ───────────────────────
  Future<String?> uploadAvatar({
    required String uid,
    required File file,
  }) async {
    try {
      final String privateKey = EnvConfig.imagekitPrivateKey;
      final String basicAuth = 'Basic ${base64Encode(utf8.encode('$privateKey:'))}';

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: '${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
        'fileName': '${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg',
        'folder': '/avatars',
        'useUniqueFileName': 'true',
      });

      final response = await _dio.post(
        _uploadUrl,
        data: formData,
        options: Options(
          headers: {
            'Authorization': basicAuth,
          },
        ),
      );

      if (response.statusCode == 200) {
        final url = response.data['url'] as String;
        print('ImageKit Upload Success: $url');
        return url;
      }
      return null;
    } catch (e) {
      print('ImageKit Upload Error: $e');
      return null;
    }
  }

  // ── Upload Chat Image to ImageKit.io ───────────────────
  Future<String?> uploadChatImage({
    required String conversationId,
    required File file,
  }) async {
    try {
      final String privateKey = EnvConfig.imagekitPrivateKey;
      final String basicAuth = 'Basic ${base64Encode(utf8.encode('$privateKey:'))}';

      final fileName = DateTime.now().millisecondsSinceEpoch.toString();

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: '$fileName.jpg',
        ),
        'fileName': '$fileName.jpg',
        'folder': '/chat_images/$conversationId',
      });

      final response = await _dio.post(
        _uploadUrl,
        data: formData,
        options: Options(
          headers: {
            'Authorization': basicAuth,
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['url'] as String;
      }
      return null;
    } catch (e) {
      print('ImageKit Chat Upload Error: $e');
      return null;
    }
  }
}
