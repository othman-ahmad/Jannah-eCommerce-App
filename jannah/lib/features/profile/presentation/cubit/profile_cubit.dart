import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/profile/data/address_model.dart';
import 'package:jannah/features/profile/data/app_user_model.dart';
import 'package:jannah/features/profile/domain/usecases/delete_address.dart';
import 'package:jannah/features/profile/domain/usecases/get_addresses.dart';
import 'package:jannah/features/profile/domain/usecases/get_profile.dart';
import 'package:jannah/features/profile/domain/usecases/save_address.dart';
import 'package:jannah/features/profile/domain/usecases/update_profile.dart';
import 'package:jannah/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfile getProfile;
  final UpdateProfile updateProfile;
  final GetAddresses getAddresses;
  final SaveAddress saveAddress;
  final DeleteAddress deleteAddress;

  int currentUserId;

  ProfileCubit({
    required this.getProfile,
    required this.updateProfile,
    required this.getAddresses,
    required this.saveAddress,
    required this.deleteAddress,
    required this.currentUserId,
  }) : super(const ProfileState());

  Future<void> loadProfileData({int? userId}) async {
    final effectiveUserId = userId ?? currentUserId;
    currentUserId = effectiveUserId;

    await Future.wait([
      loadProfile(userId: effectiveUserId),
      loadAddresses(userId: effectiveUserId),
    ]);
  }

  Future<void> loadProfile({int? userId}) async {
    final effectiveUserId = userId ?? currentUserId;
    currentUserId = effectiveUserId;

    emit(
      state.copyWith(
        profileStatus: ProfileStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final user = await getProfile(userId: effectiveUserId);
      emit(
        state.copyWith(
          profileStatus: ProfileStatus.success,
          user: user,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          profileStatus: ProfileStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadAddresses({int? userId}) async {
    final effectiveUserId = userId ?? currentUserId;
    currentUserId = effectiveUserId;

    emit(
      state.copyWith(
        addressesStatus: ProfileStatus.loading,
        clearAddressesErrorMessage: true,
      ),
    );

    try {
      final addresses = await getAddresses(userId: effectiveUserId);
      emit(
        state.copyWith(
          addressesStatus: ProfileStatus.success,
          addresses: _sortAddresses(addresses),
          clearAddressesErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          addressesStatus: ProfileStatus.failure,
          addressesErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> saveProfile(AppUser user) async {
    emit(state.copyWith(isProfileSaving: true, clearErrorMessage: true));

    try {
      final updatedUser = await updateProfile(user: user);
      currentUserId = updatedUser.userId;
      emit(
        state.copyWith(
          profileStatus: ProfileStatus.success,
          user: updatedUser,
          isProfileSaving: false,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          profileStatus: ProfileStatus.failure,
          isProfileSaving: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> saveUserAddress(Address address) async {
    emit(
      state.copyWith(isAddressSaving: true, clearAddressesErrorMessage: true),
    );

    try {
      await saveAddress(address: address);
      final addresses = await getAddresses(userId: currentUserId);
      emit(
        state.copyWith(
          addressesStatus: ProfileStatus.success,
          addresses: _sortAddresses(addresses),
          isAddressSaving: false,
          clearAddressesErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          addressesStatus: ProfileStatus.failure,
          isAddressSaving: false,
          addressesErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> removeAddress(int addressId) async {
    emit(
      state.copyWith(isAddressSaving: true, clearAddressesErrorMessage: true),
    );

    try {
      await deleteAddress(addressId: addressId);
      final addresses = await getAddresses(userId: currentUserId);
      emit(
        state.copyWith(
          addressesStatus: ProfileStatus.success,
          addresses: _sortAddresses(addresses),
          isAddressSaving: false,
          clearAddressesErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          addressesStatus: ProfileStatus.failure,
          isAddressSaving: false,
          addressesErrorMessage: e.toString(),
        ),
      );
    }
  }

  List<Address> _sortAddresses(List<Address> addresses) {
    final sortedAddresses = List<Address>.of(addresses);
    sortedAddresses.sort((a, b) {
      if (a.isDefault == b.isDefault) {
        return a.addressId.compareTo(b.addressId);
      }

      return a.isDefault ? -1 : 1;
    });

    return sortedAddresses;
  }
}
