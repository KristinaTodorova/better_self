import 'package:better_self/app_bar.dart';
import 'package:better_self/widgets/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:better_self/nav_bar.dart';
import 'package:get/get.dart';

class PlanScreen extends StatelessWidget {
  final NameController nameController = Get.put(NameController());
  
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: const CustomAppBar(),
      body:
        Column(
        children:[
         Text(
              'Welcome back, ${nameController.name}!', // Heading text
              style: const TextStyle(
                fontSize: 32,         // Large font size for h1 equivalent
                fontWeight: FontWeight.bold, // Bold font weight
              ),
            ),
           Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.sunny, color: Colors.yellow, size: 40),
                title: const Text(
                  'Plan Your Day',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Set your top priorities and tasks.'),
                onTap: () {
                  Get.toNamed('/tasks');
                },
              ),
            ),
            const SizedBox(height: 16),

            // Second Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.self_improvement, color: Color((0xFF6C7A89)), size: 40),
                title: const Text(
                  'Track Your Routine',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Keep up with your daily habits.'),
                onTap: () {
                  Get.toNamed('/routine/:type');
                },
              ),
            ),
            const SizedBox(height: 16),

            // Third Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.nightlight_round, color: Colors.purple, size: 40),
                title: const Text(
                  'Reflect with Gratitude',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('List things you’re grateful for.'),
                onTap: () {
                  Get.toNamed('/grateful');
                },
              ),
            ),
          ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
      );
  }

}