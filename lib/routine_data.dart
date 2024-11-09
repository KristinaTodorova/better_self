import 'package:get/get.dart';
import 'package:flutter/material.dart';

class RoutineTask {
  final String title;
  final String subtitle;
  final IconData icon;
  bool isChecked;

  RoutineTask({required this.title, required this.subtitle, required this.icon, this.isChecked = false});

  Map<String, dynamic> toJson() => {
        'title': title,
        'isChecked': isChecked,
        'subtitle': subtitle,
        'icon': icon.codePoint,
      };

  // Create from JSON (Map) when loading from Hive
  factory RoutineTask.fromJson(Map<String, dynamic> json) {
    return RoutineTask(
      title: json['title'] as String,
      isChecked: json['isChecked'] as bool,
      subtitle: json['subtitle'] as String,
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
    );
  }
}

class Routine {
  final String title;
  final int index;
  final IconData icon;
  final List<RoutineTask> tasks;

  Routine({required this.title, required this.icon, required this.index, required this.tasks});

  // Convert Routine to JSON
  Map<String, dynamic> toJson() => {
        'title': title,
        'index': index,
        'icon': icon.codePoint, // Store icon as its codePoint
        'tasks': tasks.map((task) => task.toJson()).toList(), // Convert each RoutineTask to JSON
      };

  // Create Routine from JSON
  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      title: json['title'] as String,
      index: json['index'] as int,
      icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'), // Convert back to IconData
      tasks: (json['tasks'] as List<dynamic>)
          .map((taskJson) => RoutineTask.fromJson(Map<String, dynamic>.from(taskJson)))
          .toList(),
    );
  }

}

var allRoutines = <Routine>[
  Routine(
    title: 'The must-haves',
    icon: Icons.check_circle,
    index: 0,
    tasks: <RoutineTask>[
      RoutineTask(title: 'Drink Water', subtitle: '2l per day', icon: Icons.local_drink),
      RoutineTask(title: 'Set your goals for the day', subtitle: 'You can find them in the plan section', icon: Icons.checklist),
      RoutineTask(title: 'Exercise', subtitle: '30 mins a day', icon: Icons.fitness_center),
      RoutineTask(title: 'Focused work', subtitle: '2 hours', icon: Icons.book),
      RoutineTask(title: 'Sleep 8 Hours', subtitle: 'Regular sleep schedule', icon: Icons.bedtime),
    ],
  ),
  Routine(
    title: 'Morning routine',
    icon: Icons.wb_sunny,
    index: 1,
    tasks: <RoutineTask>[
      RoutineTask(title: 'Drink Water', subtitle: 'Start your day hydrated', icon: Icons.local_drink),
      RoutineTask(title: 'Eat a healthy breakfast', subtitle: 'Morning stretch or workout', icon: Icons.fitness_center),
      RoutineTask(title: 'Set your goals for the day', subtitle: 'You can find them in the plan section', icon: Icons.checklist),
      RoutineTask(title: 'Read a book or listen to something inspiring', subtitle: 'Expand your mind', icon: Icons.book),
      RoutineTask(title: 'Meditate', subtitle: '10 mins of mindfulness', icon: Icons.self_improvement),
    ],
  ),
  Routine(
    title: 'Staying fit',
    icon: Icons.fitness_center,
    index: 2,
    tasks: <RoutineTask>[
      RoutineTask(title: 'Drink Water', subtitle: 'Start your day hydrated', icon: Icons.local_drink),
      RoutineTask(title: 'Eat balanced meals', subtitle: 'Make sure you get enough protein, healthy fats and whole carbs', icon: Icons.fitness_center),
      RoutineTask(title: 'Exercise', subtitle: 'Choose your favourite strength or cardio workout', icon: Icons.fitness_center),
      RoutineTask(title: 'Walk 10.000 steps', subtitle: 'Build stamina and increase your energy levels', icon: Icons.local_drink),
      RoutineTask(title: 'Track Progress', subtitle: 'Log your results', icon: Icons.track_changes),
    ],
  ),
  Routine(
    title: 'Better sleep',
    icon: Icons.bedtime,
    index: 3,
    tasks: <RoutineTask>[
      RoutineTask(title: 'Limit screen time in the evening', subtitle: 'At least 1 hour before bed', icon: Icons.phone_disabled),
      RoutineTask(title: 'No coffee after 2pm', subtitle: 'Consistent schedule', icon: Icons.alarm),
      RoutineTask(title: 'Read a book', subtitle: 'Wind down', icon: Icons.book),
      RoutineTask(title: 'Express gratitude', subtitle: 'Write down the things you are grateful for in the gratefulness tab', icon: Icons.self_improvement),
      RoutineTask(title: 'Meditate', subtitle: '10 mins of mindfulness', icon: Icons.self_improvement),
    ],
  ),
  Routine(
    title: 'The Aalto Special',
    icon: Icons.school,
    index: 4,
    tasks: <RoutineTask>[
      RoutineTask(title: 'Focused work on programming projects', subtitle: '+ looking for a place to deploy all said projects for free.', icon: Icons.menu_book),
      RoutineTask(title: 'Wait an eternity for lunch at Taffa', subtitle: 'you know the Bolognese is worth it.', icon: Icons.edit),
      RoutineTask(title: 'Have a hot chocolate @ DF Kitchen', subtitle: 'and convince yourself not to steal the cute cups.', icon: Icons.feedback),
      RoutineTask(title: 'Spend 12 hours at Design Factory', subtitle: 'crying is forbidden in the silent area.', icon: Icons.lightbulb),
      RoutineTask(title: 'Get 8 hours of sleep', subtitle: '(optional)', icon: Icons.checklist),
    ],
  ),
].obs; // .obs to make it a reactive list if using GetX