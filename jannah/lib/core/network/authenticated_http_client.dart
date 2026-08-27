import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:jannah/core/local/app_preferences.dart';

typedef UnauthorizedHandler = Future<void> Function();

class AuthenticatedHttpClient extends http.BaseClient {
  AuthenticatedHttpClient({
    http.Client? inner,
    UnauthorizedHandler? onUnauthorized,
  }) : _inner = inner ?? http.Client(),
       _onUnauthorized = onUnauthorized;

  final http.Client _inner;
  final UnauthorizedHandler? _onUnauthorized;
  bool _isHandlingUnauthorized = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = _readStoredToken();
    if (token != null && token.isNotEmpty) {
      request.headers.putIfAbsent('Authorization', () => 'Bearer $token');
    }

    final response = await _inner.send(request);

    if (response.statusCode == 401) {
      await _handleUnauthorized();
    }

    return response;
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }

  String? _readStoredToken() {
    final box = Hive.box<dynamic>(AppPreferences.authBoxName);
    final rawUser = box.get(AppPreferences.currentAuthUserKey);

    if (rawUser is! Map<dynamic, dynamic>) {
      return null;
    }

    final userJson = Map<String, dynamic>.from(rawUser);
    for (final key in const [
      'Token',
      'token',
      'accessToken',
      'access_token',
      'jwt',
    ]) {
      final value = userJson[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }

    return null;
  }

  Future<void> _handleUnauthorized() async {
    if (_isHandlingUnauthorized) {
      return;
    }

    _isHandlingUnauthorized = true;
    final box = Hive.box<dynamic>(AppPreferences.authBoxName);
    await box.delete(AppPreferences.authSessionStatusKey);
    await box.delete(AppPreferences.currentAuthUserKey);
    await box.flush();

    await _onUnauthorized?.call();
  }
}
