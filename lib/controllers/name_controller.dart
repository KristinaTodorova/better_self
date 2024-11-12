import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:better_self/controllers/nav_controller.dart';


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