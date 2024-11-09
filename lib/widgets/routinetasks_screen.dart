import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routine_screen.dart';
import 'package:better_self/nav_bar.dart';
import 'package:better_self/app_bar.dart';

class RoutineTaskScreen extends StatelessWidget {
  final RoutineController routineController = Get.put(RoutineController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Obx(() {
  var routine = routineController.selectedRoutine.value;

  if (routine == null) {
    // Show a message if no routine is selected
    return const Center(child: Text("No routine selected"));
  } else {
    // Build the list of tasks for the selected routine
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text(
            'Daily routine',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Row(children: [
            
            Text(
            routine.title,
            style: const TextStyle(
            fontSize: 20,
            ),
          ),

          ElevatedButton(onPressed: () {
            Get.toNamed('/routine');
          }, 
          child: 
          const Text('Change routine')
          ),
          ],
          ),
  
        Expanded(
          child: ListView.builder(
            itemCount: routine.tasks.length,
            itemBuilder: (context, index) {
              var task = routine.tasks[index];
              return ListTile(
                leading: Icon(task.icon, color: Colors.blueAccent),
                title: Text(task.title),
                subtitle: Text(task.subtitle),
                trailing: Checkbox(
                  value: task.isChecked,
                  onChanged: (value) {
                    routineController.toggleRoutineTask(index);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}),
    bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
