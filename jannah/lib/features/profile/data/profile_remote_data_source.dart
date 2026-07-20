import 'package:jannah/features/profile/data/address_model.dart';
import 'package:jannah/features/profile/data/app_user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<AppUser> fetchUser({required int userId});

  Future<AppUser> updateUser({required AppUser user});

  Future<List<Address>> fetchAddresses({required int userId});

  Future<Address> saveAddress({required Address addressToSave});

  Future<void> deleteAddress({required int addressId});
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

  final List<Address> _addresses = [
    Address(
      addressId: 1,
      userId: 1,
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
      userId: 1,
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
  ];

  static int _nextAddressId = 3;

  @override
  Future<AppUser> fetchUser({required int userId}) async {
    final user = _users[userId];

    if (user == null) {
      throw Exception('User not found');
    }
    _printState();
    return AppUser.fromJson(user.toJson());
  }

  @override
  Future<AppUser> updateUser({required AppUser user}) async {
    _users[user.userId] = AppUser.fromJson(user.toJson());
    _printState();
    return fetchUser(userId: user.userId);
  }

  @override
  Future<List<Address>> fetchAddresses({required int userId}) async {
    _printAddresses();

    return _addresses.isNotEmpty
        ? _addresses
              .where((address) => address.userId == userId)
              .map((address) => Address.fromJson(address.toJson()))
              .toList(growable: false)
        : [];
  }

  @override
  Future<Address> saveAddress({required Address addressToSave}) async {
    if (addressToSave.isDefault) {
      _clearDefaultAddress(userId: addressToSave.userId);
    }

    final existingAddressIndex = _addresses.indexWhere(
      (address) => address.addressId == addressToSave.addressId,
    );
    if (existingAddressIndex != -1) {
      _addresses.removeAt(existingAddressIndex);
    }

    final bool thereIsADefaultAddress = _addresses.any(
      (address) => address.userId == addressToSave.userId && address.isDefault,
    );
    if (!thereIsADefaultAddress) {
      addressToSave = addressToSave.copyWith(isDefault: true);
    }

    _addresses.add(
      Address.fromJson(
        addressToSave.copyWith(addressId: _nextAddressId).toJson(),
      ),
    );
    _nextAddressId++;
    _printAddresses();
    return Address.fromJson(addressToSave.toJson());
  }

  @override
  Future<void> deleteAddress({required int addressId}) async {
    Address? addressToDelete = _addresses.firstWhere(
      (address) => address.addressId == addressId,
      orElse: () => throw Exception('Address not found'),
    );
    if (addressToDelete.isDefault) {
      final userAddresses = _addresses
          .where((address) => address.userId == addressToDelete.userId)
          .toList();
      if (userAddresses.length > 1) {
        final newDefaultAddress = userAddresses.firstWhere(
          (address) => address.addressId != addressId,
        );
        final updatedAddress = newDefaultAddress.copyWith(isDefault: true);
        _addresses[_addresses.indexOf(newDefaultAddress)] = updatedAddress;
      }
    }
    _addresses.removeWhere((address) => address.addressId == addressId);
    _printAddresses();
  }

  void _clearDefaultAddress({required int userId}) {
    for (var address in _addresses) {
      if (address.isDefault && address.userId == userId) {
        final updatedAddress = address.copyWith(isDefault: false);
        _addresses[_addresses.indexOf(address)] = updatedAddress;
      }
    }
  }

  void _printState() {
    print('Users:');
    _users.forEach((userId, user) {
      print(
        'User ID: $userId, \nName: ${user.name}, \nImageUrl: ${user.profileImage} \nEmail: ${user.email} \nPhone: ${user.phone}, \nCreated At: ${user.createdAt}',
      );
    });
  }

  void _printAddresses() {
    print('Addresses:');
    for (final address in _addresses) {
      print(
        'Address ID: ${address.addressId}, \nUser ID: ${address.userId}, \nType: ${address.addressType}, \nLine: ${address.addressLine}, \nCity: ${address.city}, \nState: ${address.state}, \nCountry: ${address.country}, \nPostal Code: ${address.postalCode}, \nLatitude: ${address.latitude}, \nLongitude: ${address.longitude}, \nIs Default: ${address.isDefault}',
      );
      print('--------------------------------------------------');
    }
  }
}
