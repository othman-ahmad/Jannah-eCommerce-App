import 'package:jannah/features/profile/data/address_model.dart';
import 'package:jannah/features/profile/domain/profile_repository.dart';

class GetAddresses {
  final ProfileRepository repository;

  const GetAddresses(this.repository);

  Future<List<Address>> call() {
    return repository.getAddresses();
  }
}
