import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NavigationController extends GetxController {
  // Observable to track the current index for navigation
  var currentIndex = 1.obs;

  // Function to navigate to a specific screen by index
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
      // Morning: Navigate to /tasks
      Future.microtask(() => Get.toNamed('/tasks'));
    } else if (hour >= 12 && hour < 17) {
      // Afternoon: Navigate to /routine
      Future.microtask(() => Get.toNamed('/routine/:type'));
    } else {
      // Evening or other times: Navigate to /grateful
      Future.microtask(() => Get.toNamed('/grateful'));
    }

  }
}

class CustomBottomNavBar extends StatelessWidget {
  final NavigationController navigationController = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          currentIndex: navigationController.currentIndex.value,
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
              icon: Icon(Icons.bar_chart),
              label: 'Progress',
            ),
          ],
        ));
  }
}