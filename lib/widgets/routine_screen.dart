import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:better_self/app_bar.dart';
import 'package:better_self/models/routine_model.dart';
import 'package:better_self/controllers/routine_controller.dart';

class RoutineScreen extends StatelessWidget {
  final RoutineController routineController = Get.put(RoutineController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'DAILY ROUTINE',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 92, 64, 134),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose a routine based on your goals (click to view details):',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: allRoutines.length,
                  itemBuilder: (context, index) {
                    final routine = allRoutines[index];
                    return RoutineCard(routine: routine, text: routine.title);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoutineCard extends StatelessWidget {
  final RoutineController routineController = Get.put(RoutineController());
  final String text;
  final Routine routine;

  RoutineCard({required this.text, required this.routine});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ExpansionTile(
        leading: Icon(routine.icon, color: const Color.fromARGB(255, 92, 64, 134)),
        title: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
        children: routine.tasks.map((task) {
          return ListTile(
            leading: Icon(task.icon, color: Colors.grey),
            title: Text(task.title),
            subtitle: Text(task.subtitle),
          );
        }).toList(),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.black),
          onPressed: () {
            routineController.updateSelectedRoutine(routine.index);
            Get.toNamed('/routine/${routine.index}');
          },
        ),
      ),
    );
  }
}
