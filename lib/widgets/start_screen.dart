import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:better_self/app_bar.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:better_self/nav_bar.dart';

class NameController extends GetxController{
  final NavigationController navigationController = Get.put(NavigationController());

  final storage = Hive.box("storage");
  
  RxString name = ''.obs;

  NameController(): name = ''.obs{
    name.value = storage.get('name') ?? '';
  }

  void setName (String newName) {
    if (newName.isNotEmpty){
      name.value = newName;
      storage.put('name', name.value);
    }
  }
  }

class StartScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final NameController nameController = Get.put(NameController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Center vertically
              children: [
                // Introductory quote text
                const Text(
                  "Yesterday I was clever, so I wanted to change the world. Today I am wise, so I am changing myself.",
                  style: TextStyle(
                    fontSize: 9,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Welcome prompt
                const Text(
                  "Let’s embark on a journey of growth and gratitude. What should I call you as we begin?",
                  style: TextStyle(fontSize: 18),
                ),
                
                const SizedBox(height: 20),
                
                // Name input field
                FormBuilderTextField(
                  name: 'name', // Required for FormBuilder
                  decoration: const InputDecoration(
                    labelText: "Enter your name",
                    border: OutlineInputBorder(),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Continue button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      // Manual validation
                      final name = _formKey.currentState?.fields['name']?.value ?? '';
                      if (name.isNotEmpty) {
                        nameController.setName(name);
                        Get.toNamed('/routine');
                      } else {
                        // Show an error if the name is empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Why are you so secretive with your name? :('),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text("Continue"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
