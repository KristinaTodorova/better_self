import 'package:better_self/widgets/grateful_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:better_self/nav_bar.dart';
import 'package:better_self/app_bar.dart';
import 'package:better_self/controllers/routine_controller.dart';
import 'package:better_self/controllers/nav_controller.dart';
import 'package:better_self/controllers/grateful_controller.dart';
import 'package:better_self/controllers/task_controller.dart';


class ProgressScreen extends StatelessWidget {
  
  final RoutineController routineController = Get.put(RoutineController());
  final TaskController taskController = Get.put(TaskController());
  final GratefulController gratefulController = Get.put(GratefulController());

  @override
  Widget build(BuildContext context) {
    const Color darkPurple = Color.fromARGB(255, 92, 64, 134);
    double screenWidth = MediaQuery.of(context).size.width;
    const double maxWidth = 1500;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Row(
          children: [
          if (screenWidth > 768)
            Obx(() => NavigationRail(
                  selectedIndex: Get.find<NavigationController>().currentIndex.value,
                  onDestinationSelected: Get.find<NavigationController>().navigateToPage,
                  extended: true,
                  labelType: NavigationRailLabelType.none,
                  backgroundColor: const Color.fromARGB(255, 239, 229, 251),
                  selectedIconTheme: const IconThemeData(color: darkPurple),
                  selectedLabelTextStyle: const TextStyle(color: darkPurple),
                  unselectedIconTheme: const IconThemeData(color: Colors.grey),
                  unselectedLabelTextStyle: const TextStyle(color: Colors.grey),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.calendar_today),
                      label: Text('Plan'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Now'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.insights),
                      label: Text('Progress'),
                    ),
                  ],
                )),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.insights,
                        color: darkPurple,
                        size: 50,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'YOUR PROGRESS',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: darkPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        'Daily routine',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Obx(() {
                        return SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: routineController.completionPercentage / 100,
                            strokeWidth: 30.0,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation<Color>(darkPurple),
                          ),
                        );
                      }),
                      const SizedBox(width: 50),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'You have completed ${routineController.completionPercentage}% of your daily routine.',
                              style: const TextStyle(fontSize: 18),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkPurple,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {
                                Get.toNamed('/routine/:type');
                              },
                              child: const Text('See what is left'),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  const Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        'Top 3 priorities',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Obx(() => Text(
                        'So far, you have completed ${taskController.completedTaskCount.value} tasks.',
                        style: const TextStyle(fontSize: 18),
                      )),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      leading: Obx(
                        () => Checkbox(
                          value: taskController.extraTask[0].isChecked,
                          activeColor: darkPurple,
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
                  const SizedBox(height: 15),
                  const Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        'Gratefulness',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  gratefulController.gratitudeList.length == 1
                      ? const Text(
                          'You at least have the design factory to be grateful for - not bad but is it really just that?',
                          style: TextStyle(fontSize: 18))
                      : Text(
                          'You have at least ${gratefulController.gratituteItems} things to be grateful for ...and many more coming!',
                          style: const TextStyle(fontSize: 18),
                        ),
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                  const SizedBox(height: 15),
                ],
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
