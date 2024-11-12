import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:better_self/models/task_model.dart';

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