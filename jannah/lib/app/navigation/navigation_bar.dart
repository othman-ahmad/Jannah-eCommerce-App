import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jannah/app/navigation/navigation_cubit.dart';
import 'package:jannah/features/favourites/presentation/favourites_screen.dart';
import 'package:jannah/features/home_page/presentation/home_page_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JannahNavigationBar extends StatelessWidget {
  const JannahNavigationBar({super.key});

  Widget _svgIcon(String path, {double size = 24.0}) {
    return SvgPicture.asset(path, width: size, height: size);
  }

  List<BottomNavigationBarItem> get _navBarItems => [
    BottomNavigationBarItem(
      icon: _svgIcon('assets/icons/home_border.svg', size: 20),
      activeIcon: _svgIcon('assets/icons/home_filled.svg', size: 26),
      label: 'Home',
      backgroundColor: Colors.white,
    ),
    BottomNavigationBarItem(
      icon: _svgIcon('assets/icons/checkout_border.svg'),
      activeIcon: _svgIcon('assets/icons/checkout_filled.svg', size: 28),
      label: 'Search',
      backgroundColor: Colors.white,
    ),
    BottomNavigationBarItem(
      icon: _svgIcon('assets/icons/favourite_border.svg'),
      activeIcon: _svgIcon('assets/icons/favourite_filled.svg'),
      label: 'Cart',
      backgroundColor: Colors.white,
    ),
    BottomNavigationBarItem(
      icon: _svgIcon('assets/icons/profile_border.svg'),
      activeIcon: _svgIcon('assets/icons/profile_filled.svg', size: 28),
      label: 'Profile',
      backgroundColor: Colors.white,
    ),
  ];

  List<Widget> get _navBarScreens => [
    HomePageScreen(),
    Center(child: Text('Checkout Screen')),
    FavouritesScreen(),
    Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: _navBarScreens[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: _navBarItems,
            currentIndex: currentIndex,
            onTap: (index) {
              context.read<NavigationCubit>().goToTab(index);
            },
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
          ),
        );
      },
    );
  }
}
