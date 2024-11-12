import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:better_self/controllers/routine_controller.dart';
import 'package:better_self/nav_bar.dart';
import 'package:better_self/app_bar.dart';

class RoutineTaskScreen extends StatelessWidget {
  final RoutineController routineController = Get.put(RoutineController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Row(
        children: [
          if (screenWidth > 768)
            CustomBottomNavBar(),
          Expanded(child: Obx(() {
        var routine = routineController.selectedRoutine.value;

        if (routine == null) {
          // Show a message if no routine is selected
          return const Center(child: Text("No routine selected"));
        } else {
          // Build the list of tasks for the selected routine
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Icon(
                      Icons.self_improvement,
                      color: Color.fromARGB(255, 92, 64, 134),
                      size: 50,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'DAILY ROUTINE',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 92, 64, 134),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    routine.title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: routine.tasks.length,
                    itemBuilder: (context, index) {
                      var task = routine.tasks[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          children: [
                            Icon(task.icon, color: const Color.fromARGB(255, 92, 64, 134)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ListTile(
                                title: Text(task.title),
                                subtitle: Text(task.subtitle),
                              ),
                            ),
                            Checkbox(
                              value: task.isChecked,
                              onChanged: (value) {
                                routineController.toggleRoutineTask(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 92, 64, 134),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed('/routine');
                      },
                      child: const Text('Change Routine'),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),),],),
      bottomNavigationBar: screenWidth <= 768 ? CustomBottomNavBar() : null,
    );
  }
}