import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'logo.png', // Path to the logo image file in assets
            width: 40,          // Set logo width
            height: 40,         // Set logo height
          ),
          const SizedBox(width: 10), // Space between logo and text
          const Text(
            'BetterSelf',
            style: TextStyle(
              fontSize: 20,      // Customize font size for app name
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}