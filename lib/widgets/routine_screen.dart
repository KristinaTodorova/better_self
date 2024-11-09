import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:better_self/app_bar.dart';
import 'package:better_self/routine_data.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class RoutineController extends GetxController {
  final storage = Hive.box("storage");
  var selectedRoutine = Rx<Routine?>(null); // Reactive variable for the selected routine

  @override
void onInit() {
  super.onInit();
  final storedRoutine = storage.get('selectedRoutine');
  if (storedRoutine != null) {
    selectedRoutine.value = Routine.fromJson(Map<String, dynamic>.from(storedRoutine));
  }
}

  RoutineController(){
    final savedRoutineIndex = storage.get('selectedRoutineIndex');
    if (savedRoutineIndex != null) {
      selectedRoutine.value = allRoutines[savedRoutineIndex];
    }
    else{
      Get.toNamed('/routine');
    }
  }

  void updateSelectedRoutine(int index) {
    if (index >= 0) {
      selectedRoutine.value = allRoutines[index];
      storage.put('selectedRoutineIndex', index);
    }
  }

  int get completedTasksCount {
    return selectedRoutine.value?.tasks.where((task) => task.isChecked).length ?? 0;
  }

  double get completionPercentage {
    final totalTasks = selectedRoutine.value?.tasks.length ?? 0;
    if (totalTasks == 0) return 0;
    return (completedTasksCount / totalTasks) * 100;
  }

  void toggleRoutineTask(int index) {
     if (selectedRoutine.value != null) {
    // Toggle the current value of isChecked
    selectedRoutine.value?.tasks[index].isChecked = !selectedRoutine.value!.tasks[index].isChecked;
    // Save the updated routine to storage
    storage.put(
      'selectedRoutine',
      selectedRoutine.value?.toJson(), // Store the updated Routine object
    );

    // Refresh the selectedRoutine to update the UI
    selectedRoutine.refresh();
  }
  }
}

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
            const Text(
              'Progress is not achieved by luck or accident, but by working on yourself daily.',
              style: TextStyle(
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Daily routine',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose a routine based on your goals:',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),

            // Wrap the ListView in Expanded
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
        leading: Icon(routine.icon, color: Colors.blueAccent),
        title: Text(
          text,
          style: const TextStyle(fontSize: 16),
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
