import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'widgets/start_screen.dart';
import 'widgets/plan_screen.dart';
import 'widgets/tasks_screen.dart';
import 'widgets/routine_screen.dart';
import 'widgets/grateful_screen.dart';
import 'widgets/routinetasks_screen.dart';
import 'widgets/progress_screen.dart';

import 'package:better_self/controllers/nav_controller.dart';
import 'package:better_self/controllers/grateful_controller.dart';
import 'package:better_self/controllers/name_controller.dart';


Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("storage");
  Get.lazyPut<NameController>(() => NameController());
  Get.lazyPut<GratefulController>(() => GratefulController());

  runApp( MainApp());
}

class MainApp extends StatelessWidget {
   MainApp({super.key});
   final NameController nameController = Get.put(NameController());
   final NavigationController navigationController = Get.put(NavigationController());

   String getInitialRoute() {
    if (nameController.name.value.isEmpty) {
      return '/start';
    } else {
      final int hour = DateTime.now().hour;
      if (hour >= 6 && hour < 12) {
        return '/tasks';  // In the morning: Go to Tasks Screen
      } else if (hour >= 12 && hour < 17) {
        return '/routine';  // In the afternoon: Go to Routine Screen
      } else {
        return '/grateful';  // In the evening: Go to Grateful Screen
      }
    }
  }
   
  @override
  Widget build(BuildContext context) {

    return  GetMaterialApp(
      initialRoute: getInitialRoute(),
      getPages: [
        GetPage(name: '/start', page: () => StartScreen()),
        GetPage(name: '/plan', page: () => PlanScreen()),
        GetPage(name: '/tasks', page: () => TaskScreen()),
        GetPage(name: '/routine', page: () => RoutineScreen()),
        GetPage(name: '/routine/:type', page: () => RoutineTaskScreen()),
        GetPage(name: '/grateful', page: () => GratefulScreen()),
        GetPage(name: '/progress', page: () => ProgressScreen()),
      ],
      );
  }
}
