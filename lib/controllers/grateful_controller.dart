import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:better_self/models/grateful_model.dart';

class GratefulController extends GetxController {
  final storage = Hive.box("storage");
  var gratitudeList = <GratitudeItem>[
    GratitudeItem(text: "design factory", date: DateTime.now()),
  ].obs;

  GratefulController() {
    final storedList = storage.get('gratitudeList') as List<dynamic>?;
    if (storedList != null) {
      gratitudeList.value = storedList
          .map((item) => GratitudeItem.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
  }

  void addGratitudeItem(String item) {
    if (item.isNotEmpty) {
      final newItem = GratitudeItem(text: item, date: DateTime.now());
      gratitudeList.add(newItem);
      storage.put(
        'gratitudeList',
        gratitudeList.map((item) => item.toJson()).toList(),
      );
    }
  }

  int get gratituteItems {
    return gratitudeList.length;
  }

  List<GratitudeItem> get todayGratitudeItems {
    final today = DateTime.now();
    return gratitudeList.where((item) =>
        item.date.year == today.year &&
        item.date.month == today.month &&
        item.date.day == today.day).toList();
  }
}