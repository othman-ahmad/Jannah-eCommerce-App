import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jannah/features/cart/presentation/favourites_screen.dart';
import 'package:jannah/features/home_page/presentation/home_page_screen.dart';

class JannahNavigationBar extends StatefulWidget {
  const JannahNavigationBar({super.key});

  @override
  State<JannahNavigationBar> createState() => _JannahNavigationBarState();
}

class _JannahNavigationBarState extends State<JannahNavigationBar> {
  int _currentIndex = 0;

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
    Center(child: Text('checkout Screen')),
    FavouritesScreen(),
    Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navBarScreens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navBarItems,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }
}
