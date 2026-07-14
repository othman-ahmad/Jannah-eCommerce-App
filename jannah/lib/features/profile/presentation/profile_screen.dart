import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jannah/app/navigation/navigation_cubit.dart';
import 'package:jannah/features/profile/data/app_user_model.dart';
import 'package:jannah/features/profile/presentation/widgets/settings_option.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final AppUser user = AppUser(
    userId: 1,
    name: 'John Doe',
    email: 'othman@example.com',
    phone: '123-456-7890',
    profileImage:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
    createdAt: DateTime.now(),
  );
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(30, 0, 0, 0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              horizontalTitleGap: 20,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(user.profileImage ?? ''),
              ),
              title: Text(
                user.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.phone ?? user.email!,
                style: TextStyle(fontSize: 14),
              ),
              trailing: InkWell(
                onTap: () {
                  // Handle edit profile action
                },
                child: SvgPicture.asset(
                  'assets/icons/edit_icon.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          SettingsOption(
            icon:
                'assets/icons/home_filled.svg', // TODO: Replace with actual icon path
            title: 'My Addresses',
            onTap: () {},
          ),
          SettingsOption(
            icon:
                'assets/icons/home_filled.svg', // TODO: Replace with actual icon path
            title: 'Payment Methods',
            onTap: () {
              // TODO: Navigate to a screen that says "Payment Methods coming soon"
            },
          ),
          SettingsOption(
            icon:
                'assets/icons/home_filled.svg', // TODO: Replace with actual icon path
            title: 'About Jannah',
            onTap: () {},
          ),
          SettingsOption(
            icon:
                'assets/icons/home_filled.svg', // TODO: Replace with actual icon path
            title: 'Logout',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
