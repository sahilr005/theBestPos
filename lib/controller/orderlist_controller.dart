import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:order/utils/common_method.dart';
import 'package:order/utils/repository/network_repository.dart';

class OrderListController extends GetxController {
  DateTime toDate = DateTime.now();
  DateTime fromDate = DateTime.now();
  List orderData = [];

  orderList(BuildContext context) async {
    var tdt =
        "${DateFormat.d().format(toDate)}-${DateFormat.M().format(toDate)}-${DateFormat.y().format(toDate)}";
    var fdt =
        "${DateFormat.d().format(fromDate)}-${DateFormat.M().format(fromDate)}-${DateFormat.y().format(fromDate)}";

    var res = await networkRepository.orderList(context, fdt, tdt);
    log(res.toString());
    if (res["status"] == "failure") {
      CommonMethod().getXSnackBar('Error', res["status"], Colors.red);
    }
    if (res["orders"] != null) {
      orderData = res["orders"];
      update();
    }
    update();
  }
}
