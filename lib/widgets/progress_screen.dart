import 'package:better_self/widgets/grateful_screen.dart';
import 'package:better_self/widgets/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:better_self/nav_bar.dart';
import 'package:better_self/app_bar.dart';
import 'routine_screen.dart';

class ProgressScreen extends StatelessWidget {
  final RoutineController routineController = Get.put(RoutineController());
  final TaskController taskController = Get.put(TaskController());
  final GratefulController gratefulController = Get.put(GratefulController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
      children: [
         const Text(
        'Your Progress',
        style: TextStyle(fontSize: 24),
      ),
      Row(children: [

        Obx(() { return
                  SizedBox(
                width: 200, // Define width and height for the indicator
                height: 200,
                child:
                  CircularProgressIndicator(
                    value: routineController.completionPercentage/100,
                    strokeWidth: 45.0,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
                  ),
                  );
        //put a progress bar with percentage of the routine
        },
        ),
        SizedBox(
                width: 200, // Define width and height for the indicator
                height: 200,
                child:
          Column(children: [
        Text(
        'You have completed ${routineController.completionPercentage}% of your daily routine.',
        style: const TextStyle(fontSize: 20),
      ),
      ElevatedButton(onPressed: () {Get.toNamed('/routine/:type');}, child: const Text('See what is left'))
      ],
      ),
      ),
      ],
      ),

      Obx(() => Text(
                  'So far, you have completed ${taskController.completedTaskCount.value} tasks.',
                  style: const TextStyle(fontSize: 20),
                )),

      Card(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  elevation: 2,
  child: ListTile(
    leading: Obx(
      () => Checkbox(
        value: taskController.extraTask[0].isChecked,
        onChanged: (bool? value) {
          taskController.toggleExtraTask();
        },
      ),
    ),
    title: Obx(
      () => Text(
        taskController.extraTask[0].title,
        style: TextStyle(
          fontSize: 16,
          decoration: taskController.extraTask[0].isChecked
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
    ),
  ),
),
       gratefulController.gratitudeList.length==1
        ? const Text(
        'You at least have the design factory to be grateful for - not bad but is it really just that?',
        style: TextStyle(fontSize: 20))

      :Text(
        'You have at least ${gratefulController.gratituteItems} things to be grateful for (that we know of) ...and many more coming!',
        style: const TextStyle(fontSize: 20),
      ),
      Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: gratefulController.gratitudeList.length,
                    itemBuilder: (context, index) {
                      final gratitudeItem = gratefulController.gratitudeList[index];
                      return GratitudeCard(
                        text: gratitudeItem.text,
                        date: gratitudeItem.date,
                      );
                    },
                  ),
                ),
              ),

      const Text(
        'If I really want to improve my situation, I can work on the one thing over which I have control - myself.',
        style: TextStyle(fontSize: 20),
      ),
      ],
    ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
