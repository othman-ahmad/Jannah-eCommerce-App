import 'package:jannah/features/profile/data/address_model.dart';
import 'package:jannah/features/profile/data/app_user_model.dart';
import 'package:jannah/features/profile/data/profile_remote_data_source.dart';
import 'package:jannah/features/profile/domain/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  const ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AppUser> getUser({required int userId}) {
    return remoteDataSource.fetchUser(userId: userId);
  }

  @override
  Future<AppUser> updateUser({required AppUser user}) {
    return remoteDataSource.updateUser(user: user);
  }

  @override
  Future<List<Address>> getAddresses({required int userId}) {
    return remoteDataSource.fetchAddresses(userId: userId);
  }

  @override
  Future<Address> saveAddress({required int userId, required Address address}) {
    return remoteDataSource.saveAddress(userId: userId, address: address);
  }

  @override
  Future<void> deleteAddress({required int userId, required int addressId}) {
    return remoteDataSource.deleteAddress(userId: userId, addressId: addressId);
  }
}
