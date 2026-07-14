import 'package:jannah/features/profile/data/address_model.dart';
import 'package:jannah/features/profile/domain/profile_repository.dart';

class SaveAddress {
  final ProfileRepository repository;

  const SaveAddress(this.repository);

  Future<Address> call({required int userId, required Address address}) {
    return repository.saveAddress(userId: userId, address: address);
  }
}
