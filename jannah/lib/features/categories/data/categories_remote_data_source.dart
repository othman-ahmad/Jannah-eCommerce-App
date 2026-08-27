import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jannah/features/categories/data/category_model.dart';

abstract class CategoriesRemoteDataSource {
  Future<List<Category>> fetchCategories();
}

class ApiCategoriesRemoteDataSource implements CategoriesRemoteDataSource {
  ApiCategoriesRemoteDataSource({
    http.Client? client,
    String baseUrl = 'http://192.168.1.21:5241/api/categories',
  }) : _client = client ?? http.Client(),
       _baseUri = Uri.parse(baseUrl);

  final http.Client _client;
  final Uri _baseUri;

  @override
  Future<List<Category>> fetchCategories() async {
    final response = await _client
        .get(_baseUri, headers: const {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 15));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        _extractErrorMessage(response.body) ??
            'Categories request failed (${response.statusCode}).',
      );
    }

    final decoded = _decodeJson(response.body);
    final categoriesJson = _unwrapList(decoded);
    return categoriesJson.map(Category.fromJson).toList();
  }

  Object? _decodeJson(String responseBody) {
    if (responseBody.trim().isEmpty) {
      return null;
    }

    return jsonDecode(responseBody);
  }

  List<Map<String, dynamic>> _unwrapList(Object? decoded) {
    final Object? categories = decoded is Map<String, dynamic>
        ? decoded['categories'] ??
              decoded['Categories'] ??
              decoded['items'] ??
              decoded['Items'] ??
              decoded['data'] ??
              decoded['result']
        : decoded;

    if (categories is List) {
      return categories
          .whereType<Map>()
          .map((categoryJson) => Map<String, dynamic>.from(categoryJson))
          .toList(growable: false);
    }

    throw const FormatException('Expected a category list from the API.');
  }

  String? _extractErrorMessage(String responseBody) {
    try {
      final decoded = _decodeJson(responseBody);
      if (decoded is Map) {
        final json = Map<String, dynamic>.from(decoded);

        for (final key in const [
          'message',
          'Message',
          'error',
          'Error',
          'title',
        ]) {
          final value = json[key];
          if (value is String && value.isNotEmpty) {
            return value;
          }
        }

        final errors = json['errors'];
        if (errors is Map && errors.isNotEmpty) {
          return errors.values
              .expand((value) => value is List ? value : [value])
              .map((value) => value.toString())
              .join('\n');
        }
      }
    } catch (_) {
      return responseBody.trim().isEmpty ? null : responseBody;
    }

    return responseBody.trim().isEmpty ? null : responseBody;
  }
}
