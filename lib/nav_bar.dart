import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NavigationController extends GetxController {
  // Observable to track the current index for the navigation
  var currentIndex = 1.obs;

  void navigateToPage(int index) {
    currentIndex.value = index;

    switch (index) {
      case 0:
        Get.toNamed('/plan');
        break;
      case 1:
        goToToday();
        break;
      case 2:
        Get.toNamed('/progress');
        break;
    }
  }
  
  void goToToday() {
    
    final int hour = DateTime.now().hour;

    // Determine which route to navigate to based on the time of day
    if (hour >= 6 && hour < 12) {
      Future.microtask(() => Get.toNamed('/tasks'));
    } else if (hour >= 12 && hour < 17) {
      Future.microtask(() => Get.toNamed('/routine/:type'));
    } else {
      Future.microtask(() => Get.toNamed('/grateful'));
    }
  }
}

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
                extended: true, // Show the labels next to the icons
                labelType: NavigationRailLabelType.none, // Labels should be next to the icons
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