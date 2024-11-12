import 'package:better_self/app_bar.dart';
import 'package:better_self/controllers/name_controller.dart';
import 'package:flutter/material.dart';
import 'package:better_self/nav_bar.dart';
import 'package:get/get.dart';

class PlanScreen extends StatelessWidget {
  final NameController nameController = Get.put(NameController());
  
  @override
  Widget build(BuildContext context) {
    const Color darkPurple = Color.fromARGB(255, 92, 64, 134);
    double screenWidth = MediaQuery.of(context).size.width;
    const double maxWidth = 1500;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Row(
        children: [
          if (screenWidth > 768)
            CustomBottomNavBar(),
          Expanded(
          child: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Welcome back, ${nameController.name}!',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                height: 110,
                child: Center(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                    leading: const Icon(Icons.sunny, color: darkPurple, size: 50),
                    title: const Text(
                      'Plan Your Day',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Set your top priorities and tasks.',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Get.toNamed('/tasks');
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                height: 110,
                child: Center(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                    leading: const Icon(Icons.self_improvement, color: darkPurple, size: 50),
                    title: const Text(
                      'Track Your Routine',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), 
                    ),
                    subtitle: const Text(
                      'Keep up with your daily habits.',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Get.toNamed('/routine/:type');
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                height: 110,
                child: Center(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                    leading: const Icon(Icons.nightlight_round, color: darkPurple, size: 50),
                    title: const Text(
                      'Reflect with Gratitude',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'List things you’re grateful for.',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Get.toNamed('/grateful');
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),),
     ],
          ),
        ),
     ),
      bottomNavigationBar: screenWidth <= 768 ? CustomBottomNavBar() : null
    );
  }
}
