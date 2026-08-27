import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jannah/features/home_page/data/promotion_model.dart';

abstract class PromotionsRemoteDataSource {
  Future<List<Promotion>> fetchPromotions();
}

class ApiPromotionsRemoteDataSource implements PromotionsRemoteDataSource {
  ApiPromotionsRemoteDataSource({
    http.Client? client,
    String baseUrl = 'http://192.168.1.21:5241/api/promotions',
  }) : _client = client ?? http.Client(),
       _baseUri = Uri.parse(baseUrl);

  final http.Client _client;
  final Uri _baseUri;

  @override
  Future<List<Promotion>> fetchPromotions() async {
    final response = await _client
        .get(_baseUri, headers: const {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 15));

    _throwIfRequestFailed(response, 'Promotions request failed');

    return _unwrapList(
      _decodeJson(response.body),
      'promotions',
    ).map(Promotion.fromJson).toList(growable: false);
  }

  Object? _decodeJson(String responseBody) {
    if (responseBody.trim().isEmpty) {
      return null;
    }

    return jsonDecode(responseBody);
  }

  List<Map<String, dynamic>> _unwrapList(Object? decoded, String listName) {
    final Object? list = decoded is Map
        ? decoded[listName] ??
              decoded[_capitalize(listName)] ??
              decoded['items'] ??
              decoded['Items'] ??
              decoded['data'] ??
              decoded['Data'] ??
              decoded['result'] ??
              decoded['Result']
        : decoded;

    if (list is List) {
      return list
          .whereType<Map>()
          .map((itemJson) => Map<String, dynamic>.from(itemJson))
          .toList(growable: false);
    }

    throw FormatException('Expected a $listName list from the API.');
  }

  void _throwIfRequestFailed(http.Response response, String fallbackMessage) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    throw Exception(
      _extractErrorMessage(response.body) ??
          '$fallbackMessage (${response.statusCode}).',
    );
  }

  String? _extractErrorMessage(String responseBody) {
    try {
      final decoded = _decodeJson(responseBody);
      if (decoded is! Map) {
        return responseBody.trim().isEmpty ? null : responseBody;
      }

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
    } catch (_) {
      return responseBody.trim().isEmpty ? null : responseBody;
    }

    return null;
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}
