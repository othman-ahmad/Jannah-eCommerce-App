import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:jannah/core/local/app_preferences.dart';
import 'package:jannah/features/authentication/data/auth_user_model.dart';

abstract class AuthenticationRemoteDataSource {
  String hashPassword({required String password});

  Future<AuthUser> login({
    required String emailOrPhone,
    required String password,
  });

  Future<AuthUser> register({
    required String fullName,
    required String emailOrPhone,
    required String password,
  });
}

class ApiAuthenticationRemoteDataSource
    implements AuthenticationRemoteDataSource {
  ApiAuthenticationRemoteDataSource({
    http.Client? client,
    String baseUrl = 'http://192.168.1.21:5241/api/auth',
  }) : _client = client ?? http.Client(),
       _baseUri = Uri.parse(baseUrl);

  final http.Client _client;
  final Uri _baseUri;

  @override
  String hashPassword({required String password}) {
    const secretKey = 'A8+fsd465sdg5ddg/*sgh8Jf4Ds';
    final hmac = Hmac(sha256, utf8.encode(secretKey));
    final digest = hmac.convert(utf8.encode(password));
    return digest.toString();
  }

  @override
  Future<AuthUser> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final response = await _post(
      pathSegment: 'login',
      body: {
        'fullName': '',
        'emailOrPhone': emailOrPhone.trim(),
        'password': hashPassword(password: password),
      },
    );

    return _readAuthenticatedUser(
      response.body,
      fallbackFullName: '',
      fallbackEmailOrPhone: emailOrPhone.trim(),
    );
  }

  @override
  Future<AuthUser> register({
    required String fullName,
    required String emailOrPhone,
    required String password,
  }) async {
    final response = await _post(
      pathSegment: 'register',
      body: {
        'fullName': fullName.trim(),
        'emailOrPhone': emailOrPhone.trim(),
        'password': hashPassword(password: password),
      },
    );

    return _readAuthenticatedUser(
      response.body,
      fallbackFullName: fullName.trim(),
      fallbackEmailOrPhone: emailOrPhone.trim(),
    );
  }

  Future<AuthUser> getCurrentUser({
    required String token,
    String fallbackFullName = '',
    String fallbackEmailOrPhone = '',
  }) async {
    final response = await _client
        .get(
          _uriFor('me'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 15));

    _throwIfRequestFailed(response);

    final userJson = _extractUserJson(_decodeJson(response.body));
    return AuthUser.fromJson(
      _mergeUserJson(
        userJson,
        token: token,
        fallbackFullName: fallbackFullName,
        fallbackEmailOrPhone: fallbackEmailOrPhone,
      ),
    );
  }

  Future<http.Response> _post({
    required String pathSegment,
    required Map<String, dynamic> body,
  }) async {
    final response = await _client
        .post(
          _uriFor(pathSegment),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));

    _throwIfRequestFailed(response);
    return response;
  }

  Future<AuthUser> _readAuthenticatedUser(
    String responseBody, {
    required String fallbackFullName,
    required String fallbackEmailOrPhone,
  }) async {
    final decoded = _decodeJson(responseBody);
    final token = _extractToken(decoded);

    if (token == null || token.isEmpty) {
      final userJson = _extractUserJson(decoded);
      if (userJson != null) {
        return AuthUser.fromJson(
          _mergeUserJson(
            userJson,
            fallbackFullName: fallbackFullName,
            fallbackEmailOrPhone: fallbackEmailOrPhone,
          ),
        );
      }

      throw const FormatException(
        'Authentication response did not include a token.',
      );
    }

    try {
      return await getCurrentUser(
        token: token,
        fallbackFullName: fallbackFullName,
        fallbackEmailOrPhone: fallbackEmailOrPhone,
      );
    } catch (_) {
      final userJson = _extractUserJson(decoded);
      return AuthUser.fromJson(
        _mergeUserJson(
          userJson,
          token: token,
          fallbackFullName: fallbackFullName,
          fallbackEmailOrPhone: fallbackEmailOrPhone,
        ),
      );
    }
  }

  Uri _uriFor(String pathSegment) {
    final path = _baseUri.path.endsWith('/')
        ? '${_baseUri.path}$pathSegment'
        : '${_baseUri.path}/$pathSegment';

    return _baseUri.replace(path: path);
  }

  void _throwIfRequestFailed(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    throw Exception(
      _extractErrorMessage(response.body) ??
          'Authentication request failed (${response.statusCode}).',
    );
  }

  Object? _decodeJson(String responseBody) {
    if (responseBody.trim().isEmpty) {
      return null;
    }

    return jsonDecode(responseBody);
  }

  String? _extractToken(Object? decoded) {
    if (decoded is String && decoded.isNotEmpty) {
      return decoded;
    }

    final json = _asMap(decoded);
    if (json == null) {
      return null;
    }

    for (final key in const [
      'Token',
      'token',
      'accessToken',
      'access_token',
      'jwt',
    ]) {
      final value = json[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }

    for (final key in const [
      'data',
      'result',
      'auth',
      'authentication',
      'user',
    ]) {
      final token = _extractToken(json[key]);
      if (token != null && token.isNotEmpty) {
        return token;
      }
    }

    return null;
  }

  Map<String, dynamic>? _extractUserJson(Object? decoded) {
    final json = _asMap(decoded);
    if (json == null) {
      return null;
    }

    if (_looksLikeUserJson(json)) {
      return json;
    }

    for (final key in const [
      'user',
      'User',
      'account',
      'Account',
      'profile',
      'Profile',
      'data',
      'result',
    ]) {
      final userJson = _extractUserJson(json[key]);
      if (userJson != null) {
        return userJson;
      }
    }

    return null;
  }

  Map<String, dynamic> _mergeUserJson(
    Map<String, dynamic>? userJson, {
    String? token,
    String fallbackFullName = '',
    String fallbackEmailOrPhone = '',
  }) {
    final merged = <String, dynamic>{};

    if (token != null && token.isNotEmpty) {
      merged.addAll(_claimsFromToken(token));
      merged['Token'] = token;
    }

    if (fallbackFullName.isNotEmpty) {
      merged['FullName'] = fallbackFullName;
    }
    if (fallbackEmailOrPhone.isNotEmpty) {
      merged['EmailOrPhone'] = fallbackEmailOrPhone;
    }

    if (userJson != null) {
      merged.addAll(userJson);
    }

    if (token != null && token.isNotEmpty) {
      merged['Token'] = token;
    }

    return merged;
  }

  Map<String, dynamic> _claimsFromToken(String token) {
    final parts = token.split('.');
    if (parts.length < 2) {
      return const {};
    }

    try {
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final claims = _asMap(jsonDecode(payload));
      if (claims == null) {
        return const {};
      }

      return {
        'nameIdentifier':
            claims['nameid'] ??
            claims['sub'] ??
            claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'],
        'name':
            claims['name'] ??
            claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'],
      };
    } catch (_) {
      return const {};
    }
  }

  bool _looksLikeUserJson(Map<String, dynamic> json) {
    return json.containsKey('UserId') ||
        json.containsKey('userId') ||
        json.containsKey('id') ||
        json.containsKey('FullName') ||
        json.containsKey('fullName') ||
        json.containsKey('emailOrPhone') ||
        json.containsKey('EmailOrPhone');
  }

  Map<String, dynamic>? _asMap(Object? value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  String? _extractErrorMessage(String responseBody) {
    try {
      final decoded = _decodeJson(responseBody);
      final json = _asMap(decoded);
      if (json == null) {
        return responseBody.trim().isEmpty ? null : responseBody;
      }

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

      final errors = _asMap(json['errors']);
      if (errors != null && errors.isNotEmpty) {
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
}
