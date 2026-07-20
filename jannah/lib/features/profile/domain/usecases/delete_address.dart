import 'package:jannah/features/profile/domain/profile_repository.dart';

class DeleteAddress {
  final ProfileRepository repository;

  const DeleteAddress(this.repository);

  Future<void> call({required int addressId}) {
    return repository.deleteAddress(addressId: addressId);
  }
}
