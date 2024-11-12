import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:better_self/app_bar.dart';
import 'package:better_self/nav_bar.dart';
import 'package:better_self/controllers/nav_controller.dart';
import 'package:better_self/controllers/grateful_controller.dart';


class GratefulScreen extends StatelessWidget {
  final GratefulController gratefulController = Get.put(GratefulController());
  final _formKey = GlobalKey<FormBuilderState>();
  final NavigationController navigationController = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
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
            CustomBottomNavBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.nightlight_round,
                          color: Color.fromARGB(255, 92, 64, 134),
                          size: 50,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'GRATEFULNESS',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 92, 64, 134),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Gratitude turns what we have into enough. Take a moment to think of something you’re grateful for today - no matter how small it is.',
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
          ),
        ],
          ),
        ),
      ),
      bottomNavigationBar: screenWidth <= 768 ? CustomBottomNavBar() : null,
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
        trailing: Text(
          '${date.day}/${date.month}/${date.year}',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }
}
