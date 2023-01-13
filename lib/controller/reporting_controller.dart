import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:order/utils/repository/network_repository.dart';

class ReportingController extends GetxController {
  DateTime fromDate = DateTime.now();
  int sortValue = 0;
  int paymentMode = 0;
  List reportingData = [];
  List shopData = [];
  String shopName = "";
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
  List orderTime = [];

  // Set cashSet = {};
  // List cashList1 = [];
  // List cashAmount = [];
  // List cashStatus = [];
  // List cashItem = [];

  List eftpoList = [];
  Set eftpoSet = {};

  List<double> amcl = [];
  double totalAmount = 0.0;

  Future<bool> shopNameGet(BuildContext context) async {
    var date = DateTime.now();
    var newDate = DateTime(date.year, date.month, date.day - 1);
    var tdt =
        "${DateFormat.d().format(newDate)}-${DateFormat.M().format(newDate)}-${DateFormat.y().format(newDate)}";
    var fdt =
        "${DateFormat.d().format(newDate)}-${DateFormat.M().format(newDate)}-${DateFormat.y().format(newDate)}";
    // "${DateFormat.d().format(fromDate)}-${DateFormat.M().format(fromDate)}-${DateFormat.y().format(fromDate)}";
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
    orderTime = [];
    calMap = {};

    // cashSet = {};
    // cashList1 = [];
    // cashAmount = [];
    // cashStatus = [];
    // cashItem = [];
    itemMapCal = {};
    amcl = [];
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
          orderTime.add(reportingData[i]["otime"]);
          orderSet.add(reportingData[i]["ordno"]);
          // if (reportingData[i]["status"].toString() == "9") {
          //   cashList1.add(reportingData[i]);
          // } else {
          //   eftpoList.add(reportingData[i]);
          // }
        }
        // cashCal();
        calMap = cal();
        itemMapCal = itemCal();

        update();
      }
      update();
    }
    // log(reportingData.toString());
    return true;
  }

  Map calMap = {};
  Map cal() {
    List<double> amcl = [];
    for (var i = 0; i < categoryList.length; i++) {
      amcl.add(double.parse(categoryAmount
          .toString()
          .replaceAll(" ", "")
          .replaceAll("[", "")
          .replaceAll("]", "")
          .split(",")[i]
          .toString()));
      if (calMap.containsKey(categoryList[i])) {
        calMap.update(categoryList[i], (value) {
          return "${value + "," + categoryAmount[i]}";
        });
      } else {
        calMap.addAll({categoryList[i]: categoryAmount[i]});
      }
    }
    totalAmount = amcl.fold<double>(
        0, (prev, value) => prev + (double.parse(value.toString())));

    return calMap;
  }

  Map itemMapCal = {};
  Map itemCal() {
    List<double> amcl = [];
    for (var i = 0; i < itemList.length; i++) {
      amcl.add(double.parse(itemAmount
          .toString()
          .replaceAll(" ", "")
          .replaceAll("[", "")
          .replaceAll("]", "")
          .split(",")[i]
          .toString()));
      if (itemMapCal.containsKey(itemList[i])) {
        itemMapCal.update(itemList[i], (value) {
          return "${value + "," + itemAmount[i]}";
        });
      } else {
        itemMapCal.addAll({itemList[i]: itemAmount[i]});
      }
    }
    totalAmount = amcl.fold<double>(
        0, (prev, value) => prev + (double.parse(value.toString())));

    return itemMapCal;
  }

  // Map cashCal() {
  //   for (var i = 0; i < cashList1.length; i++) {
  //     cashSet.add(cashList1[i]["ordno"]);
  //     cashAmount.add(cashList1[i]["totamt"]);
  //     // cashList.add(cashList1[i]["ordno"]);
  //     cashStatus.add(cashList1[i]["status"]);
  //     cashItem.add(cashList1[i]["itemnm"]);
  //   }
  //   log(cashSet.length.toString());
  //   log("Cash Item ${cashItem.length}");

  //   for (var i = 0; i < eftpoList.length; i++) {
  //     eftpoSet.add(eftpoList[i]["ordno"]);
  //   }
  //   Map map = {};
  //   return map;
  // }

  List orderCal() {
    Map orderCalMap = {};
    Map statusMap = {};
    Map itemsMap = {};
    Map itemsTime = {};
    for (var i = 0; i < orderList.length; i++) {
      amcl.add(double.parse(orderAmount
          .toString()
          .replaceAll(" ", "")
          .replaceAll("[", "")
          .replaceAll("]", "")
          .split(",")[i]
          .toString()));
      if (orderCalMap.containsKey(orderList[i])) {
        orderCalMap.update(orderList[i], (value) {
          return "${value + "," + orderAmount[i]}";
        });
      } else {
        orderCalMap.addAll({orderList[i]: orderAmount[i]});
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
      if (itemsTime.containsKey(orderList[i])) {
        itemsTime.update(orderList[i], (value) {
          return "${value + "," + orderTime[i]}";
        });
      } else {
        itemsTime.addAll({orderList[i]: orderTime[i]});
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

    Map cashItemMap = {};
    Map cashCalMap = {};

    // for (var i = 0; i < cashList1.length; i++) {
    //   if (cashCalMap.containsKey(cashList1[i])) {
    //     cashCalMap.update(cashList1[i], (value) {
    //       return "${value + "," + cashAmount[i]}";
    //     });
    //   } else {
    //     cashCalMap.addAll({cashList1[i]: cashAmount[i]});
    //   }
    //   if (cashItemMap.containsKey(cashList1[i])) {
    //     cashItemMap.update(cashList1[i], (value) {
    //       return "${value + "," + cashItem[i]}";
    //     });
    //   } else {
    //     cashItemMap.addAll({cashList1[i]: cashItem[i]});
    //   }
    // }

    return [
      orderCalMap, // === 0
      statusMap, // === 1
      itemsMap, // === 2
      cashCount, // === 3
      cashPayment.toPrecision(2), // === 4
      cashItemMap, // === 5
      cashCalMap, // === 6
      itemsTime, //7
    ];
  }
}
