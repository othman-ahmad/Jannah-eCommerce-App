import 'package:jannah/features/profile/data/address_model.dart';
import 'package:jannah/features/profile/data/app_user_model.dart';

abstract class ProfileRepository {
  Future<AppUser> getUser();

  Future<AppUser> updateUser({required AppUser user});

  Future<List<Address>> getAddresses();

  Future<Address> saveAddress({required Address address});

  Future<void> deleteAddress({required int addressId});
}
