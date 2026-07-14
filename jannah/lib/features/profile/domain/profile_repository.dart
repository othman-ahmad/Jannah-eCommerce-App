import 'package:jannah/features/profile/data/address_model.dart';
import 'package:jannah/features/profile/data/app_user_model.dart';

abstract class ProfileRepository {
  Future<AppUser> getUser({required int userId});

  Future<AppUser> updateUser({required AppUser user});

  Future<List<Address>> getAddresses({required int userId});

  Future<Address> saveAddress({required int userId, required Address address});

  Future<void> deleteAddress({required int userId, required int addressId});
}
