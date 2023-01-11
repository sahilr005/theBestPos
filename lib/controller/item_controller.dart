import 'package:get/get.dart';

class ItemController extends GetxController {
  String statusValue = 'Active';
  DateTime datePick = DateTime.now();
  var items = [
    "Active",
    "For today",
    "Until date",
    "Until we activate it again"
  ];
}
