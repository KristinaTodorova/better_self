import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:better_self/app_bar.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:better_self/nav_bar.dart';

class NameController extends GetxController {
  final NavigationController navigationController = Get.put(NavigationController());

  final storage = Hive.box("storage");

  RxString name = ''.obs;

  NameController() : name = ''.obs {
    name.value = storage.get('name') ?? '';
  }

  void setName(String newName) {
    if (newName.isNotEmpty) {
      name.value = newName;
      storage.put('name', name.value);
    }
  }
}

class StartScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final NameController nameController = Get.put(NameController());

  static const Color darkPurple = Color.fromARGB(255, 92, 64, 134);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: Container(
          width: 350, 
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
               
                const Text(
                  "“Yesterday I was clever, so I wanted to change the world. Today I am wise, so I am changing myself.”",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15, 
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                Image.asset(
                  'mindful.png',
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                ),
                
                const Text(
                  "Let’s embark on a journey of growth and gratitude. What should I call you as we begin?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                FormBuilderTextField(
                  name: 'name', 
                  decoration: const InputDecoration(
                    labelText: "Enter your name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      final name = _formKey.currentState?.fields['name']?.value ?? '';
                      if (name.isNotEmpty) {
                        nameController.setName(name);
                        Get.toNamed('/routine');
                      } else {
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