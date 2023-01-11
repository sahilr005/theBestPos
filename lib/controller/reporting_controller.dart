import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:order/utils/repository/network_repository.dart';

class ReportingController extends GetxController {
  DateTime toDate = DateTime.now();
  DateTime fromDate = DateTime.now();
  int sortValue = 0;
  List reportingData = [];
  Set categorySet = {};
  List categoryList = [];
  List categoryAmount = [];

  Set itemSet = {};
  List itemList = [];
  List itemAmount = [];
  double totalAmount = 0.0;

  reportingAPI(BuildContext context) async {
    var tdt =
        "${DateFormat.d().format(toDate)}-${DateFormat.M().format(toDate)}-${DateFormat.y().format(toDate)}";
    var fdt =
        "${DateFormat.d().format(fromDate)}-${DateFormat.M().format(fromDate)}-${DateFormat.y().format(fromDate)}";

    reportingData = [];
    categorySet = {};
    categoryList = [];
    categoryAmount = [];
    itemSet = {};
    itemList = [];
    itemAmount = [];
    totalAmount = 0.0;
    var res = await networkRepository.repprtingCAll(context, fdt, tdt);

    if (res != null) {
      reportingData = res;
      if (reportingData.isNotEmpty) {
        for (var i = 0; i < reportingData.length; i++) {
          categoryAmount.add(reportingData[i]["totamt"]);
          categoryList.add(reportingData[i]["categ"]);
          categorySet.add(reportingData[i]["categ"]);

          itemAmount.add(reportingData[i]["totamt"]);
          itemList.add(reportingData[i]["itemnm"]);
          itemSet.add(reportingData[i]["itemnm"]);
        }
        cal();
      }
      update();
    }
    // log(reportingData.toString());
  }

  Map cal() {
    Map map = {};
    List<double> amcl = [];
    for (var i = 0; i < categoryList.length; i++) {
      amcl.add(double.parse(categoryAmount
          .toString()
          .replaceAll(" ", "")
          .replaceAll("[", "")
          .replaceAll("]", "")
          .split(",")[i]
          .toString()));
      if (map.containsKey(categoryList[i])) {
        map.update(categoryList[i], (value) {
          return "${value + "," + categoryAmount[i]}";
        });
      } else {
        map.addAll({categoryList[i]: categoryAmount[i]});
      }
    }
    totalAmount = amcl.fold<double>(
        0, (prev, value) => prev + (double.parse(value.toString())));

    return map;
  }

  Map itemCal() {
    Map map = {};
    List<double> amcl = [];
    for (var i = 0; i < itemList.length; i++) {
      amcl.add(double.parse(itemAmount
          .toString()
          .replaceAll(" ", "")
          .replaceAll("[", "")
          .replaceAll("]", "")
          .split(",")[i]
          .toString()));
      if (map.containsKey(itemList[i])) {
        map.update(itemList[i], (value) {
          return "${value + "," + itemAmount[i]}";
        });
      } else {
        map.addAll({itemList[i]: itemAmount[i]});
      }
    }
    totalAmount = amcl.fold<double>(
        0, (prev, value) => prev + (double.parse(value.toString())));

    return map;
  }
}
