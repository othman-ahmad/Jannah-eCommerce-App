import 'package:jannah/features/profile/data/address_model.dart';
import 'package:jannah/features/profile/data/app_user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<AppUser> fetchUser({required int userId});

  Future<AppUser> updateUser({required AppUser user});

  Future<List<Address>> fetchAddresses({required int userId});

  Future<Address> saveAddress({required int userId, required Address address});

  Future<void> deleteAddress({required int userId, required int addressId});
}

class MockProfileRemoteDataSource implements ProfileRemoteDataSource {
  final Map<int, AppUser> _users;

  MockProfileRemoteDataSource({List<AppUser> initialUsers = const []})
    : _users = {
        1: AppUser(
          userId: 1,
          name: 'Guest User',
          phone: '+962 7 9000 0000',
          createdAt: DateTime(2026, 1, 1),
        ),
        for (final user in initialUsers)
          user.userId: AppUser.fromJson(user.toJson()),
      };

  final Map<int, List<Address>> _addressesByUserId = {
    1: [
      Address(
        addressId: 1,
        addressType: 'Home',
        addressLine: 'Al Madina Street, Building 12',
        city: 'Amman',
        state: 'Amman',
        country: 'Jordan',
        postalCode: '11118',
        latitude: 31.9539,
        longitude: 35.9106,
        isDefault: true,
      ),
      Address(
        addressId: 2,
        addressType: 'Office',
        addressLine: 'King Hussein Business Park',
        city: 'Amman',
        state: 'Amman',
        country: 'Jordan',
        postalCode: '11831',
        latitude: 31.9754,
        longitude: 35.8438,
        isDefault: false,
      ),
    ],
  };

  int _nextAddressId = 3;

  @override
  Future<AppUser> fetchUser({required int userId}) async {
    final user = _users[userId];

    if (user == null) {
      throw Exception('User not found');
    }

    return AppUser.fromJson(user.toJson());
  }

  @override
  Future<AppUser> updateUser({required AppUser user}) async {
    _users[user.userId] = AppUser.fromJson(user.toJson());
    return fetchUser(userId: user.userId);
  }

  @override
  Future<List<Address>> fetchAddresses({required int userId}) async {
    final addresses = _addressesByUserId[userId] ?? [];
    return addresses
        .map((address) => Address.fromJson(address.toJson()))
        .toList(growable: false);
  }

  @override
  Future<Address> saveAddress({
    required int userId,
    required Address address,
  }) async {
    final addresses = _addressesByUserId.putIfAbsent(userId, () => []);
    final addressToSave = address.addressId == 0
        ? address.copyWith(addressId: _nextAddressId++)
        : address;

    if (addressToSave.isDefault) {
      _clearDefaultAddress(addresses);
    }

    final index = addresses.indexWhere(
      (item) => item.addressId == addressToSave.addressId,
    );

    if (index == -1) {
      addresses.add(Address.fromJson(addressToSave.toJson()));
    } else {
      addresses[index] = Address.fromJson(addressToSave.toJson());
    }

    if (addresses.length == 1) {
      addresses[0] = addresses[0].copyWith(isDefault: true);
    }

    if (addresses.isNotEmpty &&
        !addresses.any((address) => address.isDefault)) {
      addresses[0] = addresses[0].copyWith(isDefault: true);
    }

    return Address.fromJson(addressToSave.toJson());
  }

  @override
  Future<void> deleteAddress({
    required int userId,
    required int addressId,
  }) async {
    final addresses = _addressesByUserId[userId];

    if (addresses == null) {
      return;
    }

    final deletedAddress = addresses.where(
      (address) => address.addressId == addressId,
    );
    final wasDefault =
        deletedAddress.isNotEmpty && deletedAddress.first.isDefault;

    addresses.removeWhere((address) => address.addressId == addressId);

    if (wasDefault && addresses.isNotEmpty) {
      addresses[0] = addresses[0].copyWith(isDefault: true);
    }
  }

  void _clearDefaultAddress(List<Address> addresses) {
    for (var i = 0; i < addresses.length; i++) {
      addresses[i] = addresses[i].copyWith(isDefault: false);
    }
  }
}
