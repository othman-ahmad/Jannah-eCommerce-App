import 'package:jannah/features/profile/data/app_user_model.dart';
import 'package:jannah/features/profile/domain/profile_repository.dart';

class GetProfile {
  final ProfileRepository repository;

  const GetProfile(this.repository);

  Future<AppUser> call({required int userId}) {
    return repository.getUser(userId: userId);
  }
}
