import 'package:jannah/features/profile/data/address_model.dart';
import 'package:jannah/features/profile/data/app_user_model.dart';
import 'package:jannah/features/profile/data/profile_remote_data_source.dart';
import 'package:jannah/features/profile/domain/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  const ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AppUser> getUser() {
    return remoteDataSource.fetchUser();
  }

  @override
  Future<AppUser> updateUser({required AppUser user}) {
    return remoteDataSource.updateUser(user: user);
  }

  @override
  Future<List<Address>> getAddresses() {
    return remoteDataSource.fetchAddresses();
  }

  @override
  Future<Address> saveAddress({required Address address}) {
    return remoteDataSource.saveAddress(addressToSave: address);
  }

  @override
  Future<void> deleteAddress({required int addressId}) {
    return remoteDataSource.deleteAddress(addressId: addressId);
  }
}
