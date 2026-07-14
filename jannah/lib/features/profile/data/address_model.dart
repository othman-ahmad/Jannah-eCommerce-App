class Address {
  int addressId;
  String addresType; // e.g. Home, Appartment, Office, etc.
  String addressLine; // e.g. MyHome , Jimmy's Appartment, Office, etc.
  String city;
  String state;
  String country;
  String postalCode;
  double latitude;
  double longitude;
  bool isDefault;

  Address({
    required this.addressId,
    required this.addresType,
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
      addresType: json['address_type'] ?? '',
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
      'address_type': addresType,
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
}
