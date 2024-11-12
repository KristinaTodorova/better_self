import 'package:get/get.dart';

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