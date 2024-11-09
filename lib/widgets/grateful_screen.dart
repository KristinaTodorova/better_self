import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:better_self/app_bar.dart';
import 'package:better_self/nav_bar.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class GratitudeItem {
  final String text;
  final DateTime date;

  GratitudeItem({required this.text, required this.date});

  Map<String, dynamic> toJson() => {
        'text': text,
        'date': date.toIso8601String(),
      };

  // Create from JSON (Map) when loading from Hive
  factory GratitudeItem.fromJson(Map<String, dynamic> json) {
    return GratitudeItem(
      text: json['text'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}

class GratefulController extends GetxController {

  final storage = Hive.box("storage");

  // Observable list to hold gratitude items with date
  var gratitudeList = <GratitudeItem>[
    GratitudeItem(text: "design factory", date: DateTime.now()),
  ].obs;

   GratefulController() {
    // Load the list from Hive if it exists
    final storedList = storage.get('gratitudeList') as List<dynamic>?;
    if (storedList != null) {
      gratitudeList.value = storedList
          .map((item) => GratitudeItem.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
  }

  // Function to add a new gratitude item with the current date
  void addGratitudeItem(String item) {
    if (item.isNotEmpty) {
      final newItem = GratitudeItem(text: item, date: DateTime.now());
      gratitudeList.add(newItem);
      
      // Save the updated list to Hive
      storage.put(
        'gratitudeList',
        gratitudeList.map((item) => item.toJson()).toList(),
      );
    }
  }

  int get gratituteItems{
    return gratitudeList.length;
  }

   List<GratitudeItem> get todayGratitudeItems {
    final today = DateTime.now();
    return gratitudeList.where((item) =>
      item.date.year == today.year &&
      item.date.month == today.month &&
      item.date.day == today.day
    ).toList();
  }

  void printHiveBoxContents() {
  print(storage.toMap());
  //storage.clear();
}
}

class GratefulScreen extends StatelessWidget {
  final GratefulController gratefulController = Get.put(GratefulController());
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Gratitude turns what we have into enough.',
                style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
              ),
              const Text(
                'Take a moment to think of something you’re grateful for today—it could brighten your outlook and strengthen your resilience.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              FormBuilderTextField(
                name: 'gratefulInput',
                decoration: InputDecoration(
                  hintText: 'Add something you’re grateful for...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add, color: Colors.black),
                    onPressed: () {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        String item = _formKey.currentState?.fields['gratefulInput']?.value ?? '';
                        gratefulController.addGratitudeItem(item);
                        _formKey.currentState?.reset();
                        gratefulController.printHiveBoxContents();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: gratefulController.todayGratitudeItems.length,
                    itemBuilder: (context, index) {
                      final gratitudeItem = gratefulController.todayGratitudeItems[index];
                      return GratitudeCard(
                        text: gratitudeItem.text,
                        date: gratitudeItem.date,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class GratitudeCard extends StatelessWidget {
  final String text;
  final DateTime date;

  GratitudeCard({required this.text, required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.auto_awesome_rounded, color: Colors.amber),
        title: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
        // Display the date on the right side
        trailing: Text(
          '${date.day}/${date.month}/${date.year}', // Format date as needed
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }
}

