import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jannah/features/profile/data/address_model.dart';
import 'package:jannah/features/profile/data/app_user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<AppUser> fetchUser({required int userId});

  Future<AppUser> updateUser({required AppUser user});

  Future<List<Address>> fetchAddresses({required int userId});

  Future<Address> saveAddress({required Address addressToSave});

  Future<void> deleteAddress({required int addressId});
}

class ApiProfileRemoteDataSource implements ProfileRemoteDataSource {
  ApiProfileRemoteDataSource({
    http.Client? client,
    String baseUrl = 'http://192.168.1.75:5241/api/profile',
  }) : _client = client ?? http.Client(),
       _baseUri = Uri.parse(baseUrl);

  final http.Client _client;
  final Uri _baseUri;

  @override
  Future<AppUser> fetchUser({required int userId}) async {
    final response = await _get(_uriFor('$userId'));
    return AppUser.fromJson(_unwrapObject(_decodeJson(response.body), 'user'));
  }

  @override
  Future<AppUser> updateUser({required AppUser user}) async {
    final response = await _put(
      _uriFor('${user.userId}'),
      body: {
        'fullName': user.name,
        'email': user.email,
        'phone': user.phone,
        'profileImage': user.profileImage,
      },
    );

    if (response.body.trim().isEmpty) {
      return fetchUser(userId: user.userId);
    }

    return AppUser.fromJson(
      _unwrapObject(_decodeJson(response.body), 'user'),
    ).copyWith(userId: user.userId);
  }

  @override
  Future<List<Address>> fetchAddresses({required int userId}) async {
    final response = await _get(_uriFor('addresses/user/$userId'));
    return _unwrapList(
      _decodeJson(response.body),
      'addresses',
    ).map(Address.fromJson).toList(growable: false);
  }

  @override
  Future<Address> saveAddress({required Address addressToSave}) async {
    final response = await _post(
      _uriFor('addresses'),
      body: {
        'addressId': addressToSave.addressId,
        'userId': addressToSave.userId,
        'addressType': addressToSave.addressType,
        'addressLine': addressToSave.addressLine,
        'city': addressToSave.city,
        'state': addressToSave.state,
        'postalCode': addressToSave.postalCode,
        'country': addressToSave.country,
        'latitude': addressToSave.latitude,
        'longitude': addressToSave.longitude,
        'isDefault': addressToSave.isDefault,
      },
    );

    if (response.body.trim().isEmpty) {
      return addressToSave;
    }

    return _readSavedAddress(_decodeJson(response.body), addressToSave);
  }

  @override
  Future<void> deleteAddress({required int addressId}) async {
    await _delete(_uriFor('addresses/$addressId'));
  }

  Future<http.Response> _get(Uri uri) async {
    final response = await _client
        .get(uri, headers: const {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 15));

    _throwIfRequestFailed(response, 'Profile request failed');
    return response;
  }

  Future<http.Response> _post(
    Uri uri, {
    required Map<String, dynamic> body,
  }) async {
    final response = await _client
        .post(
          uri,
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));

    _throwIfRequestFailed(response, 'Profile request failed');
    return response;
  }

  Future<http.Response> _put(
    Uri uri, {
    required Map<String, dynamic> body,
  }) async {
    final response = await _client
        .put(
          uri,
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));

    _throwIfRequestFailed(response, 'Profile request failed');
    return response;
  }

  Future<http.Response> _delete(Uri uri) async {
    final response = await _client
        .delete(uri, headers: const {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 15));

    _throwIfRequestFailed(response, 'Profile request failed');
    return response;
  }

  Uri _uriFor(String pathSegment) {
    final path = _baseUri.path.endsWith('/')
        ? '${_baseUri.path}$pathSegment'
        : '${_baseUri.path}/$pathSegment';

    return _baseUri.replace(path: path);
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

  Object? _decodeJson(String responseBody) {
    if (responseBody.trim().isEmpty) {
      return null;
    }

    return jsonDecode(responseBody);
  }

  Map<String, dynamic> _unwrapObject(Object? decoded, String objectName) {
    if (decoded is Map) {
      final json = Map<String, dynamic>.from(decoded);
      for (final key in [
        objectName,
        _capitalize(objectName),
        'data',
        'Data',
        'result',
        'Result',
        'profile',
        'Profile',
      ]) {
        final value = json[key];
        if (value is Map) {
          return Map<String, dynamic>.from(value);
        }
      }

      return json;
    }

    throw FormatException('Expected a $objectName object from the API.');
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

  Address _readSavedAddress(Object? decoded, Address fallbackAddress) {
    final addressJson = _tryUnwrapObject(decoded, 'address');
    if (addressJson != null && _looksLikeFullAddressJson(addressJson)) {
      return Address.fromJson(addressJson);
    }

    final addressId = _readId(decoded);
    if (addressId != null) {
      return fallbackAddress.copyWith(addressId: addressId);
    }

    throw const FormatException(
      'Expected a saved address id or address object from the API.',
    );
  }

  Map<String, dynamic>? _tryUnwrapObject(Object? decoded, String objectName) {
    if (decoded is! Map) {
      return null;
    }

    final json = Map<String, dynamic>.from(decoded);
    for (final key in [
      objectName,
      _capitalize(objectName),
      'data',
      'Data',
      'result',
      'Result',
    ]) {
      final value = json[key];
      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }
    }

    return json;
  }

  bool _looksLikeFullAddressJson(Map<String, dynamic> json) {
    return json.containsKey('address_line') ||
        json.containsKey('addressLine') ||
        json.containsKey('AddressLine') ||
        json.containsKey('address_type') ||
        json.containsKey('addressType') ||
        json.containsKey('AddressType') ||
        json.containsKey('city') ||
        json.containsKey('City');
  }

  int? _readId(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is Map) {
      final json = Map<String, dynamic>.from(value);
      for (final key in const [
        'addressId',
        'AddressId',
        'address_id',
        'id',
        'Id',
        'data',
        'Data',
        'result',
        'Result',
      ]) {
        final id = _readId(json[key]);
        if (id != null) {
          return id;
        }
      }
    }

    return null;
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
