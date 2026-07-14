import 'package:jannah/features/profile/data/app_user_model.dart';
import 'package:jannah/features/profile/domain/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;

  const UpdateProfile(this.repository);

  Future<AppUser> call({required AppUser user}) {
    return repository.updateUser(user: user);
  }
}
