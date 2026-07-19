import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jannah/app/navigation/navigation_cubit.dart';
import 'package:jannah/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:jannah/features/profile/data/app_user_model.dart';
import 'package:jannah/features/profile/presentation/about_screen.dart';
import 'package:jannah/features/profile/presentation/addresses_screen.dart';
import 'package:jannah/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:jannah/features/profile/presentation/cubit/profile_state.dart';
import 'package:jannah/features/profile/presentation/widgets/settings_option.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _openAddresses(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ProfileCubit>(),
          child: const AddressesScreen(),
        ),
      ),
    );
  }

  Future<void> _showEditProfileSheet(BuildContext context, AppUser user) async {
    final cubit = context.read<ProfileCubit>();
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email ?? '');
    final phoneController = TextEditingController(text: user.phone ?? '');
    final imageController = TextEditingController(
      text: user.profileImage ?? '',
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
            ),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ProfileTextField(
                      controller: nameController,
                      label: 'Name',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    _ProfileTextField(
                      controller: emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    _ProfileTextField(
                      controller: phoneController,
                      label: 'Phone',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    _ProfileTextField(
                      controller: imageController,
                      label: 'Profile Image URL',
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 54,
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: state.isProfileSaving
                            ? null
                            : () async {
                                final updatedUser = user.copyWith(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim().isEmpty
                                      ? null
                                      : emailController.text.trim(),
                                  clearEmail: emailController.text
                                      .trim()
                                      .isEmpty,
                                  phone: phoneController.text.trim().isEmpty
                                      ? null
                                      : phoneController.text.trim(),
                                  clearPhone: phoneController.text
                                      .trim()
                                      .isEmpty,
                                  profileImage:
                                      imageController.text.trim().isEmpty
                                      ? null
                                      : imageController.text.trim(),
                                  clearProfileImage: imageController.text
                                      .trim()
                                      .isEmpty,
                                );

                                await cubit.saveProfile(updatedUser);

                                if (sheetContext.mounted) {
                                  Navigator.of(sheetContext).pop();
                                }
                              },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: state.isProfileSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/back_button_icon.svg',
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          onPressed: () {
            context.read<NavigationCubit>().goHome();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.profileStatus == ProfileStatus.loading &&
              state.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.profileStatus == ProfileStatus.failure &&
              state.user == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.errorMessage ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          final user = state.user;

          if (user == null) {
            return const Center(child: Text('No profile found'));
          }

          return RefreshIndicator(
            onRefresh: () => context.read<ProfileCubit>().loadProfileData(),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                _ProfileHeaderCard(
                  user: user,
                  onEdit: () => _showEditProfileSheet(context, user),
                ),
                if (state.defaultAddress() != null)
                  _DefaultAddressPreview(
                    address: state.defaultAddress()!.addressLine,
                    city: state.defaultAddress()!.city,
                  ),
                const SizedBox(height: 12),
                SettingsOption(
                  icon: 'assets/icons/location_pin_icon.svg',
                  title: 'My Addresses',
                  onTap: () => _openAddresses(context),
                ),
                SettingsOption(
                  icon: 'assets/icons/payment_icon.svg',
                  title: 'Payment Methods',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          appBar: AppBar(
                            leading: IconButton(
                              icon: SvgPicture.asset(
                                'assets/icons/back_button_icon.svg',
                                width: 20,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  Colors.black,
                                  BlendMode.srcIn,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            backgroundColor: Colors.white,
                            elevation: 0,
                            centerTitle: true,
                            title: const Text(
                              'Payment Methods',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          body: const Center(
                            child: Text(
                              'Payment Methods Coming Soon',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 68, 68, 68),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SettingsOption(
                  icon: 'assets/icons/about_icon.svg',
                  title: 'About Jannah',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AboutScreen()),
                    );
                  },
                ),
                SettingsOption(
                  icon: 'assets/icons/logout_icon.svg',
                  title: 'Logout',
                  onTap: () {
                    context.read<AuthenticationCubit>().logout();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final AppUser user;
  final VoidCallback onEdit;

  const _ProfileHeaderCard({required this.user, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(30, 0, 0, 0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        horizontalTitleGap: 20,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: user.profileImage == null
              ? null
              : NetworkImage(user.profileImage!),
          child: user.profileImage == null
              ? const Icon(Icons.person, color: Colors.black)
              : null,
        ),
        title: Text(
          user.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          user.phone ?? user.email ?? 'No contact information',
          style: const TextStyle(fontSize: 14),
        ),
        trailing: InkWell(
          onTap: onEdit,
          child: SvgPicture.asset(
            'assets/icons/edit_icon.svg',
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}

class _DefaultAddressPreview extends StatelessWidget {
  final String address;
  final String city;

  const _DefaultAddressPreview({required this.address, required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Default Address',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '$address, $city',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const _ProfileTextField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
      ),
    );
  }
}
