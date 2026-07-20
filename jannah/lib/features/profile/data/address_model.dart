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
      addressId: json['address_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      addressType: json['address_type'] ?? '',
      addressLine: json['address_line'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postal_code'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'user_id': userId,
      'address_type': addressType,
      'address_line': addressLine,
      'city': city,
      'state': state,
      'country': country,
      'postal_code': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
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
}
