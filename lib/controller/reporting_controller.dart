import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:order/utils/repository/network_repository.dart';

class ReportingController extends GetxController {
  DateTime toDate = DateTime.now();
  DateTime fromDate = DateTime.now();
  int sortValue = 0;
  int paymentMode = 0;
  List reportingData = [];
  List shopData = [];
  String? shopName;
  Set shopNameSet = {};

  Set categorySet = {};
  List categoryList = [];
  List categoryAmount = [];

  Set itemSet = {};
  List itemList = [];
  List itemAmount = [];

  Set orderSet = {};
  List orderList = [];
  List orderAmount = [];
  List orderStatus = [];
  List orderItem = [];

  List cashList = [];
  List eftpoList = [];
  // List cashList2 = [];
  Set eftpoSet = {};
  Set cashSet = {};

  double totalAmount = 0.0;

  Future<bool> shopNameGet(BuildContext context) async {
    var tdt =
        "${DateFormat.d().format(toDate)}-${DateFormat.M().format(toDate)}-${DateFormat.y().format(toDate)}";
    var fdt =
        "${DateFormat.d().format(fromDate)}-${DateFormat.M().format(fromDate)}-${DateFormat.y().format(fromDate)}";
    var res = await networkRepository.reportingCAll(context, fdt, tdt);
    if (res != null) {
      shopData = res;

      for (var i = 0; i < shopData.length; i++) {
        shopNameSet.add(shopData[i]["shopnm"]);
      }
      shopName = shopNameSet.toList()[0];
      log("Shop Name $shopName");
      log("Shop Name ${shopNameSet.length}");

      reportingAPI(context);

      update();
    }
    return true;
  }

  Future<bool> reportingAPI(BuildContext context, {shop}) async {
    var tdt =
        "${DateFormat.d().format(DateTime.now())}-${DateFormat.M().format(DateTime.now())}-${DateFormat.y().format(DateTime.now())}";
    var fdt =
        "${DateFormat.d().format(fromDate)}-${DateFormat.M().format(fromDate)}-${DateFormat.y().format(fromDate)}";

    reportingData = [];
    categorySet = {};
    categoryList = [];
    categoryAmount = [];
    itemSet = {};
    itemList = [];
    itemAmount = [];
    orderSet = {};
    orderList = [];
    orderAmount = [];
    orderStatus = [];
    orderItem = [];
    eftpoList = [];
    totalAmount = 0.0;
    var res =
        await networkRepository.reportingShopCAll(context, fdt, tdt, shopName);

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

          orderAmount.add(reportingData[i]["totamt"]);
          orderList.add(reportingData[i]["ordno"]);
          orderStatus.add(reportingData[i]["status"]);
          orderItem.add(reportingData[i]["itemnm"]);
          orderSet.add(reportingData[i]["ordno"]);
          if (reportingData[i]["status"].toString() == "9") {
            cashList.add(reportingData[i]);
          } else {
            eftpoList.add(reportingData[i]);
          }
        }
        cashCal();
        cal();
        itemCal();
        update();
      }
      update();
    }
    // log(reportingData.toString());
    return true;
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

  Map cashCal() {
    for (var i = 0; i < cashList.length; i++) {
      cashSet.add(cashList[i]["ordno"]);
    }
    for (var i = 0; i < eftpoList.length; i++) {
      eftpoSet.add(eftpoList[i]["ordno"]);
    }
    Map map = {};
    return map;
  }

  List orderCal() {
    Map map = {};
    Map statusMap = {};
    Map itemsMap = {};
    List<double> amcl = [];

    for (var i = 0; i < orderList.length; i++) {
      amcl.add(double.parse(orderAmount
          .toString()
          .replaceAll(" ", "")
          .replaceAll("[", "")
          .replaceAll("]", "")
          .split(",")[i]
          .toString()));
      if (map.containsKey(orderList[i])) {
        map.update(orderList[i], (value) {
          return "${value + "," + orderAmount[i]}";
        });
      } else {
        map.addAll({orderList[i]: orderAmount[i]});
      }

      if (statusMap.containsKey(orderList[i])) {
        statusMap.update(orderList[i], (value) {
          return "${value + "," + orderStatus[i]}";
        });
      } else {
        statusMap.addAll({orderList[i]: orderStatus[i]});
      }

      if (itemsMap.containsKey(orderList[i])) {
        itemsMap.update(orderList[i], (value) {
          return "${value + "," + orderItem[i]}";
        });
      } else {
        itemsMap.addAll({orderList[i]: orderItem[i]});
      }
    }
    totalAmount = amcl.fold<double>(
        0, (prev, value) => prev + (double.parse(value.toString())));
    List cashCount = [];
    double cashPayment = 0;
    for (var i = 0; i < orderStatus.length; i++) {
      if (orderStatus[i].toString() == "9") {
        cashCount.add(i);
        cashPayment = cashPayment + double.parse(orderAmount[i]);
      }
    }

    return [
      map,
      statusMap,
      itemsMap,
      cashCount,
      cashPayment.toPrecision(2),
    ];
  }
}
