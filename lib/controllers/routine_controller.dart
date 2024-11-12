import 'package:get/get.dart';
import 'package:better_self/models/routine_model.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class RoutineController extends GetxController {
  final storage = Hive.box("storage");
  var selectedRoutine = Rx<Routine?>(null);

  @override
  void onInit() {
    super.onInit();
    final storedRoutine = storage.get('selectedRoutine');
    if (storedRoutine != null) {
      selectedRoutine.value = Routine.fromJson(Map<String, dynamic>.from(storedRoutine));
    }
  }

  RoutineController() {
    final savedRoutineIndex = storage.get('selectedRoutineIndex');
    if (savedRoutineIndex != null) {
      selectedRoutine.value = allRoutines[savedRoutineIndex];
    } else {
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
      selectedRoutine.value?.tasks[index].isChecked = !selectedRoutine.value!.tasks[index].isChecked;
      storage.put(
        'selectedRoutine',
        selectedRoutine.value?.toJson(), // Store the updated Routine object
      );
      selectedRoutine.refresh();
    }
  }
}
