import 'package:jannah/features/profile/data/address_model.dart';
import 'package:jannah/features/profile/data/app_user_model.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState {
  final ProfileStatus profileStatus;
  final ProfileStatus addressesStatus;
  final AppUser? user;
  final List<Address> addresses;
  final bool isProfileSaving;
  final bool isAddressSaving;
  final String? errorMessage;
  final String? addressesErrorMessage;

  const ProfileState({
    this.profileStatus = ProfileStatus.initial,
    this.addressesStatus = ProfileStatus.initial,
    this.user,
    this.addresses = const [],
    this.isProfileSaving = false,
    this.isAddressSaving = false,
    this.errorMessage,
    this.addressesErrorMessage,
  });

  Address? defaultAddress() {
    for (final address in addresses) {
      if (address.isDefault) {
        return address;
      }
    }

    return addresses.isEmpty ? null : addresses.first;
  }

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    ProfileStatus? addressesStatus,
    AppUser? user,
    List<Address>? addresses,
    bool? isProfileSaving,
    bool? isAddressSaving,
    String? errorMessage,
    String? addressesErrorMessage,
    bool clearUser = false,
    bool clearErrorMessage = false,
    bool clearAddressesErrorMessage = false,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      addressesStatus: addressesStatus ?? this.addressesStatus,
      user: clearUser ? null : user ?? this.user,
      addresses: addresses ?? this.addresses,
      isProfileSaving: isProfileSaving ?? this.isProfileSaving,
      isAddressSaving: isAddressSaving ?? this.isAddressSaving,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      addressesErrorMessage: clearAddressesErrorMessage
          ? null
          : addressesErrorMessage ?? this.addressesErrorMessage,
    );
  }
}
