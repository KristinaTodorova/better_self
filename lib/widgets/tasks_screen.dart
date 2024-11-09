import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:better_self/app_bar.dart';
import 'package:better_self/nav_bar.dart';
import 'package:get/get.dart';
import 'routine_screen.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';


class Task {
  final String title;
  bool isChecked;
  final DateTime date;

  Task({required this.title, this.isChecked = false, required this.date});

  Map<String, dynamic> toJson() => {
        'title': title,
        'isChecked': isChecked,
        'date': date.toIso8601String(),
      };

  // Create from JSON (Map) when loading from Hive
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] as String,
      isChecked: json['isChecked'] as bool,
      date: DateTime.parse(json['date'] as String),
    );
  }
}

class TaskController extends GetxController{

  final storage = Hive.box("storage");

  var priorityTasks = <Task>[].obs;
  var extraTask = <Task>[Task(title: 'Check this one to give yourself the extra boost you deserve.', date: DateTime.now())].obs;
  var completedTaskCount = 0.obs;

  TaskController() {
    // Load the list from Hive if it exists
    final storedList = storage.get('priorityTasks') as List<dynamic>?;
    if (storedList != null) {
      priorityTasks.value = storedList
          .map((item) => Task.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    removeOldTasks();
    updateCompletedTaskCount();
  }

  void removeOldTasks() {
    final today = DateTime.now();
    priorityTasks.removeWhere((task) =>
        task.date.year != today.year ||
        task.date.month != today.month ||
        task.date.day != today.day);

    storage.put(
    'priorityTasks',
    priorityTasks.map((item) => item.toJson()).toList(),
    );
  
  }

  void updateCompletedTaskCount() {
    completedTaskCount.value = 
        priorityTasks.where((task) => task.isChecked).length +
        (extraTask[0].isChecked ? 1 : 0);
  }

  void addPriorityTask (String tasktitle) {
    if (tasktitle.isNotEmpty){
      priorityTasks.add(Task(title: tasktitle,date: DateTime.now()));

      storage.put(
        'priorityTasks',
        priorityTasks.map((item) => item.toJson()).toList(),
      );
    }
  }

   void toggleTask(int index) {
    priorityTasks[index].isChecked = !priorityTasks[index].isChecked;
    priorityTasks.refresh();
    updateCompletedTaskCount();
    storage.put(
        'priorityTasks',
        priorityTasks.map((item) => item.toJson()).toList(),
      );
  }

    void removeTask(int index) {
    priorityTasks.removeAt(index);
    updateCompletedTaskCount();
    storage.put(
        'priorityTasks',
        priorityTasks.map((item) => item.toJson()).toList(),
      );
  }

    void toggleExtraTask() {
      extraTask[0].isChecked = !extraTask[0].isChecked;
      extraTask.refresh();
      updateCompletedTaskCount();
      storage.put(
        'priorityTasks',
        priorityTasks.map((item) => item.toJson()).toList(),
      );
    }
}


class TaskScreen extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());
  final RoutineController routineController = Get.put(RoutineController());
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          const Text(
              'Your top priorities', // Heading text
              style: TextStyle(
                fontSize: 32,         // Large font size for h1 equivalent
                fontWeight: FontWeight.bold, // Bold font weight
              ),
            ),
            const Text(
              'Focus on what matters most! Enter up to 3 tasks for today to boost your productivity and avoid overwhelm. The "Law of Three" helps you stay efficient and focused—three tasks at a time is all you need for better results.', // Heading text
              style: TextStyle(
                fontSize: 10,         // Large font size for h1 equivalent
                fontStyle: FontStyle.italic, // Italic font weight
              ),
            ),
            const Text(
              'What are the three most important tasks you want to focus on today?', // Heading text
              style: TextStyle(
                fontSize: 15,         // Large font size for h1 equivalent
                fontWeight: FontWeight.bold, // Bold font weight
              ),
            ),
            FormBuilderTextField(
                name: 'taskInput',
                decoration: InputDecoration(
                  hintText: 'Today I want to...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add, color: Colors.black), // Plus icon inside the input field
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
                      // Add the new task if the limit hasn’t been reached
                      String taskTitle = _formKey.currentState?.fields['taskInput']?.value ?? '';
                      taskController.addPriorityTask(taskTitle);
                      _formKey.currentState?.reset(); // Clear input field
                    }
                      // Save and validate form input, then add to list
                      else if (_formKey.currentState?.saveAndValidate() ?? false) {
                        String tasktitle = _formKey.currentState?.fields['taskInput']?.value ?? '';
                        taskController.addPriorityTask(tasktitle);
                        _formKey.currentState?.reset(); // Clear input field
                      }
                    },
                  ),
                ),
              ),

              Expanded(child: Obx(() => ListView.builder(
                itemCount: taskController.priorityTasks.length,
                itemBuilder: (context,index) {
                  final task = taskController.priorityTasks[index];
                  final now = DateTime.now();

                  // Check if task was added today
                  final isToday = task.date.year == now.year &&
                        task.date.month == now.month &&
                        task.date.day == now.day;
                  if (isToday) {
                  return TaskCard(
                        text: taskController.priorityTasks[index].title,
                        index: index,
                      );
                    }
                    else {return const SizedBox.shrink();}
                },
              )
              ),
              ),
        ],
      ),
    ),
    
    bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class TaskCard extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());
  final String text;
  final int index;

  TaskCard({required this.text, required this.index});

  @override
  Widget build(BuildContext context){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Obx(
          () => Checkbox(
            value: taskController.priorityTasks[index].isChecked,
            onChanged: (bool? value) {
              taskController.toggleTask(index); // Update state in controller
            },
          ),
        ),
        title: Text(
          text,
          style: const TextStyle(fontSize: 16),
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