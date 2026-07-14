import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsOption extends StatelessWidget {
  SettingsOption({
    super.key,
    required this.icon,
    required this.onTap,
    required this.title,
  });
  String title;
  String icon;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: ListTile(
        leading: SvgPicture.asset(icon, width: 24, height: 24),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        trailing: SvgPicture.asset(
          'assets/icons/settings_next_icon.svg',
          width: 20,
          height: 20,
        ),
      ),
    );
  }
}
