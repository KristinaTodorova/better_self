import 'package:flutter/material.dart';

class EditRoutineScreen extends StatelessWidget {
  // List of current routine tasks
  final List<String> currentTasks = [
    'Drink Water',
    'Exercise',
    'Read a Book',
    'Meditate',
    'Sleep 8 Hours',
  ];

  // List of suggested new tasks
  final List<String> newTasks = [
    'Walk 10,000 steps',
    'Write a journal entry',
    'Stretch for 10 minutes',
    'Cook a healthy meal',
    'Limit screen time',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
        title: const Text('Edit Routine'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title for Current Tasks
            const Text(
              'Current Routine Tasks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // List of current tasks with delete icons
            ...currentTasks.map((task) {
              return ListTile(
                title: Text(task),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Placeholder for delete functionality
                  },
                ),
              );
            }).toList(),
            const Divider(height: 40),

            // Section Title for New Tasks
            const Text(
              'Add New Tasks to Routine',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // List of new tasks with add icons
            ...newTasks.map((task) {
              return ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: () {
                    // Placeholder for add functionality
                  },
                ),
                title: Text(task),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
