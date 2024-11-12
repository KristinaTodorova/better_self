import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'controllers/nav_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  final NavigationController navigationController = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

     if (screenWidth > 768) {
      return Obx(() => 
              NavigationRail(
                selectedIndex: navigationController.currentIndex.value,
                onDestinationSelected: navigationController.navigateToPage,
                extended: true,
                labelType: NavigationRailLabelType.none,
                backgroundColor: const Color.fromARGB(255, 239, 229, 251),
                selectedIconTheme: const IconThemeData(color: Color.fromARGB(255, 92, 64, 134)),
                selectedLabelTextStyle: const TextStyle(color: Color.fromARGB(255, 92, 64, 134)),
                unselectedIconTheme: const IconThemeData(color: Colors.grey),
                unselectedLabelTextStyle: const TextStyle(color: Colors.grey),
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.calendar_today),
                    label: Text('Plan'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Now'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.insights),
                    label: Text('Progress'),
                  ),
                ],
              ));
    } else {
    return Obx(() => BottomNavigationBar(
          currentIndex: navigationController.currentIndex.value,
          selectedItemColor: const Color.fromARGB(255, 92, 64, 134),
          onTap: navigationController.navigateToPage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Plan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Now',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights),
              label: 'Progress',
            ),
          ],
        ));
  }
  }
}