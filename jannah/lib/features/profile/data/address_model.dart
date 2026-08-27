class Address {
  int addressId;
  int userId;
  String addressType; // e.g. Home, Apartment, Office, etc.
  String addressLine; // e.g. My Home, Jimmy's Apartment, Office, etc.
  String city;
  String state;
  String country;
  String postalCode;
  double latitude;
  double longitude;
  bool isDefault;

  Address({
    required this.addressId,
    required this.userId,
    required this.addressType,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressId: _readInt(json, const ['address_id', 'addressId', 'AddressId']),
      userId: _readInt(json, const ['user_id', 'userId', 'UserId']),
      addressType: _readString(json, const [
        'address_type',
        'addressType',
        'AddressType',
      ]),
      addressLine: _readString(json, const [
        'address_line',
        'addressLine',
        'AddressLine',
      ]),
      city: _readString(json, const ['city', 'City']),
      state: _readString(json, const ['state', 'State']),
      country: _readString(json, const ['country', 'Country']),
      postalCode: _readString(json, const [
        'postal_code',
        'postalCode',
        'PostalCode',
      ]),
      latitude: _readDouble(json, const ['latitude', 'Latitude']),
      longitude: _readDouble(json, const ['longitude', 'Longitude']),
      isDefault: _readBool(json, const [
        'is_default',
        'isDefault',
        'IsDefault',
      ]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AddressId': addressId,
      'UserId': userId,
      'AddressType': addressType,
      'AddressLine': addressLine,
      'City': city,
      'State': state,
      'Country': country,
      'PostalCode': postalCode,
      'Latitude': latitude,
      'Longitude': longitude,
      'IsDefault': isDefault,
    };
  }

  Address copyWith({
    int? addressId,
    String? addressType,
    String? addressLine,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    double? latitude,
    double? longitude,
    bool? isDefault,
    int? userId,
  }) {
    return Address(
      addressId: addressId ?? this.addressId,
      userId: userId ?? this.userId,
      addressType: addressType ?? this.addressType,
      addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  static int _readInt(Map<String, dynamic> json, List<String> keys) {
    final value = _readValue(json, keys);
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static double _readDouble(Map<String, dynamic> json, List<String> keys) {
    final value = _readValue(json, keys);
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  static bool _readBool(Map<String, dynamic> json, List<String> keys) {
    final value = _readValue(json, keys);
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    final value = _readValue(json, keys);
    return value?.toString() ?? '';
  }

  static Object? _readValue(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json.containsKey(key)) {
        return json[key];
      }
    }
    return null;
  }
}
