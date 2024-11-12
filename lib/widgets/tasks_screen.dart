import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:better_self/app_bar.dart';
import 'package:better_self/nav_bar.dart';
import 'package:get/get.dart';
import 'package:better_self/controllers/routine_controller.dart';
import 'package:better_self/controllers/task_controller.dart';


class TaskScreen extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());
  final RoutineController routineController = Get.put(RoutineController());
  final _formKey = GlobalKey<FormBuilderState>();

  static const Color darkPurple = Color.fromARGB(255, 92, 64, 134);

  @override
  Widget build(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      const double maxWidth = 1500;

    return Scaffold(
      appBar: const CustomAppBar(),
      body:  Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Row(
        children: [
          if (screenWidth > 768)
            CustomBottomNavBar(),
          Expanded(child: 
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(children: [ Icon(
                      Icons.sunny,
                      color: Color.fromARGB(255, 92, 64, 134),
                      size: 50,
                    ),
               Text(
                'YOUR TOP PRIORITIES',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: darkPurple,
                ),
              ),
             SizedBox(height: 40),
             ],
             ),
              const Text(
                'Focus on what matters most! Enter up to 3 tasks for today to boost your productivity and avoid overwhelm. The "Law of Three" helps you stay efficient and focused—three tasks at a time is all you need for better results.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'What are the three most important tasks you want to focus on today?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              FormBuilderTextField(
                name: 'taskInput',
                decoration: InputDecoration(
                  hintText: 'Today I want to...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add, color: Colors.black),
                    onPressed: () {
                      if (taskController.priorityTasks.where((task) {
                        final now = DateTime.now();
                        return task.date.year == now.year &&
                            task.date.month == now.month &&
                            task.date.day == now.day;
                      }).length >= 3) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'I like the optimism, but try to stick to 3 really important tasks first - if one of them is not a priority, replace it with something more meaningful.',
                            ),
                          ),
                        );
                      } else if (_formKey.currentState?.saveAndValidate() ?? false) {

                        String taskTitle = _formKey.currentState?.fields['taskInput']?.value ?? '';
                        taskController.addPriorityTask(taskTitle);
                        _formKey.currentState?.reset(); // Clear input field
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: taskController.priorityTasks.length,
                    itemBuilder: (context, index) {
                      final task = taskController.priorityTasks[index];
                      final now = DateTime.now();

                      final isToday = task.date.year == now.year &&
                          task.date.month == now.month &&
                          task.date.day == now.day;
                      if (isToday) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TaskCard(
                            text: taskController.priorityTasks[index].title,
                            index: index,
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
      ],
          ),
        ),
      ),
      bottomNavigationBar: screenWidth <= 768 ? CustomBottomNavBar() : null,
    );
  }
}

class TaskCard extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());
  final String text;
  final int index;

  TaskCard({required this.text, required this.index});

  static const Color darkPurple = Color.fromARGB(255, 92, 64, 134);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Obx(
          () => Checkbox(
            value: taskController.priorityTasks[index].isChecked,
            onChanged: (bool? value) {
              taskController.toggleTask(index);
            },
            activeColor: darkPurple,
          ),
        ),
        title: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.remove, color: Colors.black),
          onPressed: () {
            taskController.removeTask(index);
          },
        ),
      ),
    );
  }
}