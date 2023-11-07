import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/config/common.dart';
import 'package:order/model/EatInItemModel.dart';
import 'package:order/model/HolidayStausModel.dart';
import 'package:order/model/dayitemsModel.dart';
import 'package:order/model/holiday_model.dart';
import 'package:order/utils/api_constants.dart';
import 'package:order/utils/common_method.dart';
import 'package:order/utils/network_dio/network_dio.dart';
import 'package:order/utils/process_indicator.dart';
import 'package:order/view/login/login.dart';

NetworkRepository networkRepository = NetworkRepository();

class NetworkRepository {
  static final NetworkRepository _networkRepository =
      NetworkRepository._internal();
  factory NetworkRepository() {
    return _networkRepository;
  }
  NetworkRepository._internal();

  FocusNode searchFocus = FocusNode();

  Future userLogin(context, email, password) async {
    try {
      var uri = Uri.https(
          "esofttechnologies.com.au",
          "/restroapp/login-api.php",
          {"unm": email, "pwd": password.toString()});
      log(uri.toString());
      final authUserResponse = await NetworkDioHttp.getDioHttpMethod(
        context: context,
        url: uri.toString(),
        // "https://esofttechnologies.com.au/restroapp/login-api.php?unm=tahmooruser&pwd=Tahmoor$#1234"
        // "${ApiAppConstants.apiEndPoint}${ApiAppConstants.login}?unm=$email&pwd=$password",
      );
      debugPrint('\x1b[97m Response : $authUserResponse');
      return await authUserResponse['body'];
    } catch (e) {
      CommonMethod().getXSnackBar("Error", e.toString(), Colors.red);
      return e.toString();
    }
  }

  Future orderList(context, fromDate, toDate) async {
    final String? token = box!.get('token');
    var uri =
        Uri.https("esofttechnologies.com.au", "/restroapp/order-list-api.php", {
      "tkn": token,
      "fdt": fromDate,
      "tdt": toDate,
    });
    try {
      final authUserResponse = await NetworkDioHttp.getDioHttpMethod(
        context: context,
        url: uri.toString(),
        // "${ApiAppConstants.apiEndPoint}${ApiAppConstants.orderlist}?tkn=$token&fdt=$fromDate&tdt=$toDate",
      );
      debugPrint('\x1b[97m Response : $authUserResponse');
      return await authUserResponse['body'];
    } catch (e) {
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      Get.off(() => LoginScreen());
      return e.toString();
    }
  }

  Future reportingShopCAll(context, fromDate, toDate, shopName) async {
    final String? token = box!.get('token');
    var uri =
        Uri.https("esofttechnologies.com.au", "/restroapp/pos-orders-api.php", {
      "tkn": token,
      "fdt": fromDate,
      "tdt": toDate,
      "shopnm": shopName,
    });
    log(uri.toString());
    try {
      final authUserResponse = await NetworkDioHttp.getDioHttpMethod(
        context: context,
        url: uri.toString(),
        // "${ApiAppConstants.apiEndPoint}${ApiAppConstants.posOrder}?tkn=$token&fdt=$fromDate&tdt=$toDate&shopnm=${shopName.toString()}",
        // "${ApiAppConstants.apiEndPoint}${ApiAppConstants.posOrder}?tkn=$token&fdt=$fromDate&tdt=$toDate&shopnm=Taj Indian Sweets")
        // .replaceAll('"', ""),
        // "https://esofttechnologies.com.au/restroapp/pos-orders-api.php?tkn=fcd27a0377626af69b438993b7976e5e&fdt=6-11-2023&tdt=6-11-2023&shopnm=Taj%20Indian%20Sweets%20%26%20Restaurant"
        // "${ApiAppConstants.apiEndPoint}${ApiAppConstants.posOrder}?tkn=$token&fdt=19-03-2022&tdt=19-03-2022&shopnm=$shopName",
      );
      debugPrint('\x1b[97m Response : $authUserResponse');
      return await authUserResponse['body'];
    } catch (e) {
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      Get.off(() => LoginScreen());
      return e.toString();
    }
  }

  Future reportingCAll(context, fromDate, toDate) async {
    final String? token = box!.get('token');
    var uri =
        Uri.https("esofttechnologies.com.au", "/restroapp/pos-orders-api.php", {
      "tkn": token,
      "fdt": fromDate,
      "tdt": toDate,
    });
    try {
      final authUserResponse = await NetworkDioHttp.getDioHttpMethod(
        context: context,
        url: uri.toString(),
        // "${ApiAppConstants.apiEndPoint}${ApiAppConstants.posOrder}?tkn=$token&fdt=$fromDate&tdt=$toDate",
      );
      debugPrint('\x1b[97m Response : $authUserResponse');
      return await authUserResponse['body'];
    } catch (e) {
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      Get.off(() => LoginScreen());
      return e.toString();
    }
  }

  Future categoryApi(context, {catid, off}) async {
    final String? token = box!.get('token');
    var uri1 = Uri.https(
        "esofttechnologies.com.au",
        "/restroapp/category-api.php",
        {"tkn": token, "catid": catid, "act": "Update", "active": off});
    var uri2 = Uri.https("esofttechnologies.com.au",
        "/restroapp/category-api.php", {"tkn": token, "act": "Show"});
    try {
      final authUserResponse = await NetworkDioHttp.getDioHttpMethod(
        context: context,
        url: catid != null ? uri1.toString() : uri2.toString(),
        // ? "${ApiAppConstants.apiEndPoint}${ApiAppConstants.category}?tkn=$token&catid=$catid=&act=Update&active=$off"
        // : "${ApiAppConstants.apiEndPoint}${ApiAppConstants.category}?tkn=$token&act=Show",
      );
      debugPrint('\x1b[97m Response : $authUserResponse');
      return await authUserResponse['body'];
    } catch (e) {
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      Get.off(() => LoginScreen());
      return e.toString();
    }
  }

  Future toppingApi(context, {name, off}) async {
    final String? token = box!.get('token');
    var uri1 = Uri.https(
        "esofttechnologies.com.au",
        "/restroapp/topping-api.php",
        {"tkn": token, "name": name, "act": "Update", "active": off});
    var uri2 = Uri.https("esofttechnologies.com.au",
        "/restroapp/topping-api.php", {"tkn": token, "act": "Show"});
    try {
      final authUserResponse = await NetworkDioHttp.getDioHttpMethod(
        context: context,
        url: name != null
            ? uri1
                .toString() // "${ApiAppConstants.apiEndPoint}${ApiAppConstants.topping}?tkn=$token&act=Update&name=$name&active=$off"
            : uri2
                .toString(), // "${ApiAppConstants.apiEndPoint}${ApiAppConstants.topping}?tkn=$token&act=Show",
      );
      debugPrint('\x1b[97m Response : $authUserResponse');
      return await authUserResponse['body'];
    } catch (e) {
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      Get.off(() => LoginScreen());
      return e.toString();
    }
  }

  Future itemApi(context, {itemID, status}) async {
    final String? token = box!.get('token');
    var uri1 = Uri.https("esofttechnologies.com.au", "/restroapp/item-api.php",
        {"tkn": token, "itemid": itemID, "act": "Update", "active": status});
    var uri2 = Uri.https("esofttechnologies.com.au", "/restroapp/item-api.php",
        {"tkn": token, "act": "Show"});

    try {
      final authUserResponse = await NetworkDioHttp.getDioHttpMethod(
          context: context,
          url: itemID != null
              ? uri1
                  .toString() // "${ApiAppConstants.apiEndPoint}${ApiAppConstants.item}?tkn=$token&itemid=$itemID&act=Update&active=$status"
              : uri2
                  .toString() // "${ApiAppConstants.apiEndPoint}${ApiAppConstants.item}?tkn=$token&act=Show",
          );
      debugPrint('\x1b[97m Response : $authUserResponse');
      return await authUserResponse['body'];
    } catch (e) {
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      Get.off(() => LoginScreen());
      return e.toString();
    }
  }

  Future<HolidayModel> holidayCall(context) async {
    Circle processIndicator = Circle();
    final String? token = box!.get('token');
    String url =
        // "https://esofttechnologies.com.au/restroapp/holiday-dt-api.php?tkn=$token";
        "${ApiAppConstants.apiEndPoint}${ApiAppConstants.holiday}?tkn=$token";
    log("url --  $url");
    try {
      final authUserResponse = await NetworkDioHttp.postDioHttpMethod(
          context: context,
          url: url,
          data: {
            "tkn": "$token",
          });
      debugPrint('\x1b[97m Response : $authUserResponse');
      HolidayModel holidayModel =
          await HolidayModel.fromJson(authUserResponse['body']);
      return await holidayModel;
    } catch (e) {
      if (context != null) processIndicator.hide(context);
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      Get.off(() => LoginScreen());
      return await HolidayModel.fromJson({});
    }
  }

  Future<HolidayStatusModel> holidayStatusCall(context) async {
    Circle processIndicator = Circle();
    final String? token = box!.get('token');
    String url =
        // "https://esofttechnologies.com.au/restroapp/holiday-dt-api.php?tkn=$token";
        "${ApiAppConstants.apiEndPoint}${ApiAppConstants.holidayStatus}?tkn=$token";
    log("url --  $url");
    try {
      final authUserResponse = await NetworkDioHttp.postDioHttpMethod(
          context: context,
          url: url,
          data: {
            "tkn": "$token",
          });
      debugPrint('\x1b[97m Response : $authUserResponse');
      HolidayStatusModel holidayModel =
          await HolidayStatusModel.fromJson(authUserResponse['body']);
      return await holidayModel;
    } catch (e) {
      if (context != null) processIndicator.hide(context);
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      Get.off(() => LoginScreen());

      return await HolidayStatusModel.fromJson({});
    }
  }

  Future updateHolidayStatus({context, title, status, description}) async {
    Circle processIndicator = Circle();
    final String? token = box!.get('token');
    String url =
        "${ApiAppConstants.apiEndPoint}${ApiAppConstants.updateHoliday}?tkn=$token";
    Map data = {
      "tkn": "$token",
      "status": status,
      "title": title,
      "description": description
    };
    log("url --  $url \n param -  $data");
    try {
      final authUserResponse = await NetworkDioHttp.postDioHttpMethod(
          context: context, url: url, data: data);
      debugPrint('\x1b[97m Response : $authUserResponse');

      return await authUserResponse['body'];
    } catch (e) {
      if (context != null) processIndicator.hide(context);
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      Get.off(() => LoginScreen());
      return "Error";
    }
  }

  Future<EatInItemModel> eatInItems({context}) async {
    Circle processIndicator = Circle();
    final String? token = box!.get('token');
    String url =
        "${ApiAppConstants.apiEndPoint}${ApiAppConstants.eatinItems}?tkn=$token";
    Map data = {"tkn": "$token"};
    log("url --  $url \n param -  $data");
    try {
      final authUserResponse = await NetworkDioHttp.postDioHttpMethod(
          context: context, url: url, data: data);
      log('\x1b[97m Response : $authUserResponse');
      EatInItemModel eatInItemModel;
      if (await authUserResponse['body'] != "") {
        eatInItemModel =
            EatInItemModel.fromJson(await authUserResponse['body']);
      } else {
        eatInItemModel = EatInItemModel(eatitems: []);
      }
      return eatInItemModel;
    } catch (e) {
      if (context != null) processIndicator.hide(context);
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      // Get.off(() => LoginScreen());
      return EatInItemModel(eatitems: []);
    }
  }

  Future<DayitemsModel> datWiseItem({context}) async {
    Circle processIndicator = Circle();
    final String? token = box!.get('token');
    String url =
        "${ApiAppConstants.apiEndPoint}${ApiAppConstants.daywiseItem}?tkn=$token";
    Map data = {"tkn": "$token"};
    log("url --  $url");
    try {
      final authUserResponse = await NetworkDioHttp.postDioHttpMethod(
          context: context, url: url, data: data);
      log('\x1b[97m Response : $authUserResponse');
      DayitemsModel dayitemsModel;
      if (await authUserResponse['body'] != "") {
        dayitemsModel = DayitemsModel.fromJson(await authUserResponse['body']);
      } else {
        dayitemsModel = DayitemsModel(dayitems: []);
      }
      return dayitemsModel;
    } catch (e) {
      if (context != null) processIndicator.hide(context);
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      // Get.off(() => LoginScreen());
      return DayitemsModel(dayitems: []);
    }
  }

  Future<DayitemsModel> datWiseItemUpdate({context, itemid, daystr}) async {
    Circle processIndicator = Circle();
    final String? token = box!.get('token');
    String url =
        "${ApiAppConstants.apiEndPoint}${ApiAppConstants.daywiseItem}?tkn=$token";
    Map data = {"tkn": "$token", "itemid": itemid, "daystr": daystr};
    log("url --  $url");
    try {
      final authUserResponse = await NetworkDioHttp.postDioHttpMethod(
          context: context, url: url, data: data);
      log('\x1b[97m Response : $authUserResponse');
      DayitemsModel dayitemsModel;
      if (await authUserResponse['body'] != "") {
        dayitemsModel = DayitemsModel.fromJson(await authUserResponse['body']);
      } else {
        dayitemsModel = DayitemsModel(dayitems: []);
      }
      return dayitemsModel;
    } catch (e) {
      if (context != null) processIndicator.hide(context);
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      // Get.off(() => LoginScreen());
      return DayitemsModel(dayitems: []);
    }
  }

  Future<EatInItemModel> onOffItems(
      {context, required String itemid, required String eatin}) async {
    Circle processIndicator = Circle();
    final String? token = box!.get('token');
    var uri1 = Uri.https(
        "esofttechnologies.com.au",
        "/restroapp/eatin-items-api.php",
        {"tkn": token, "itemid": itemid, "eatin": eatin});
    // String url =
    // "${ApiAppConstants.apiEndPoint}${ApiAppConstants.eatinItems}?tkn=$token&itemid=$itemid&eatin=$eatin";
    log("url --  $uri1");
    try {
      final authUserResponse = await NetworkDioHttp.getDioHttpMethod(
          context: context, url: uri1.toString());
      log('\x1b[97m Response : $authUserResponse');
      EatInItemModel eatInItemModel =
          EatInItemModel.fromJson(await authUserResponse['body']);
      return eatInItemModel;
    } catch (e) {
      if (context != null) processIndicator.hide(context);
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      Get.off(() => LoginScreen());
      return EatInItemModel(eatitems: []);
    }
  }

  Future<HolidayModel> addHoliday(
      {context, required toDate, required fromDate}) async {
    Circle processIndicator = Circle();
    final String? token = box!.get('token');
    var uri1 = Uri.https(
        "esofttechnologies.com.au",
        "/restroapp/holiday-dt-api.php",
        {"tkn": token, "action": "A", "fdt": fromDate, "tdt": toDate});
    // String url =
    //     "https://seven-hills.websiteorders.com.au/orders-online/holiday-dt-api.php?tkn=536576656e48696c6c735765623f&action=A&fdt=$fromDate&tdt=$toDate";
    // "${ApiAppConstants.apiEndPoint}${ApiAppConstants.holiday}";
    log("url --  $uri1");
    try {
      final authUserResponse = await NetworkDioHttp.postDioHttpMethod(
          context: context,
          url: uri1.toString(),
          data: {
            "tkn": "$token",
          });
      debugPrint('\x1b[97m Response : $authUserResponse');
      HolidayModel holidayModel =
          await HolidayModel.fromJson(authUserResponse['body']);
      return await holidayModel;
    } catch (e) {
      if (context != null) processIndicator.hide(context);
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      Get.off(() => LoginScreen());
      return await HolidayModel.fromJson({});
    }
  }

  Future<HolidayModel> editHoliday(
      {context, required toDate, required fromDate, required id}) async {
    Circle processIndicator = Circle();
    final String? token = box!.get('token');
    var uri1 = Uri.https(
        "esofttechnologies.com.au", "/restroapp/holiday-dt-api.php", {
      "tkn": token,
      "action": "E",
      "id": id,
      "fdt": fromDate,
      "tdt": toDate
    });
    // String url =
    //     "https://seven-hills.websiteorders.com.au/orders-online/holiday-dt-api.php?tkn=536576656e48696c6c735765623f&action=E&id=$id&fdt=$fromDate&tdt=$toDate";
    // "${ApiAppConstants.apiEndPoint}${ApiAppConstants.holiday}";
    log("url --  $uri1");
    try {
      final authUserResponse = await NetworkDioHttp.postDioHttpMethod(
          context: context,
          url: uri1.toString(),
          data: {
            "tkn": "$token",
          });
      debugPrint('\x1b[97m Response : $authUserResponse');
      HolidayModel holidayModel =
          await HolidayModel.fromJson(authUserResponse['body']);
      return await holidayModel;
    } catch (e) {
      if (context != null) processIndicator.hide(context);
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      Get.off(() => LoginScreen());
      return await HolidayModel.fromJson({});
    }
  }

  Future<HolidayModel> deleteHoliday({context, required id}) async {
    Circle processIndicator = Circle();
    final String? token = box!.get('token');
    var uri1 = Uri.https(
        "esofttechnologies.com.au",
        "/restroapp/holiday-dt-api.php",
        {"tkn": token, "action": "D", "id": id});
    // String url =
    //     "https://seven-hills.websiteorders.com.au/orders-online/holiday-dt-api.php?tkn=536576656e48696c6c735765623f&action=D&id=$id";
    log("url --  $uri1");
    try {
      final authUserResponse = await NetworkDioHttp.postDioHttpMethod(
          context: context,
          url: uri1.toString(),
          data: {
            "tkn": "$token",
          });
      debugPrint('\x1b[97m Response : $authUserResponse');
      HolidayModel holidayModel =
          await HolidayModel.fromJson(authUserResponse['body']);
      return await holidayModel;
    } catch (e) {
      if (context != null) processIndicator.hide(context);
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      Get.off(() => LoginScreen());
      return await HolidayModel.fromJson({});
    }
  }

  Future sizeApi(context) async {
    final String? token = box!.get('token');
    try {
      final authUserResponse = await NetworkDioHttp.getDioHttpMethod(
        context: context,
        url:
            "${ApiAppConstants.apiEndPoint}${ApiAppConstants.sizebase}?tkn=$token&act=Show",
      );
      debugPrint('\x1b[97m Response : $authUserResponse');
      return await authUserResponse['body'];
    } catch (e) {
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      Get.off(() => LoginScreen());
      return e.toString();
    }
  }

  Future sizeUpdateApi(context, {required data}) async {
    final String? token = box!.get('token');
    try {
      final authUserResponse = await NetworkDioHttp.postDioHttpMethod(
          context: context,
          url: "${ApiAppConstants.apiEndPoint}${ApiAppConstants.setSizebase}"
              "?tkn=$token",
          data: data);
      debugPrint('\x1b[97m Response : $authUserResponse');
      return await authUserResponse['body'];
    } catch (e) {
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      Get.off(() => LoginScreen());
      return e.toString();
    }
  }

  Future orderDetails(context, oid) async {
    final String? token = box!.get('token');
    try {
      final authUserResponse = await NetworkDioHttp.getDioHttpMethod(
        context: context,
        url:
            "${ApiAppConstants.apiEndPoint}${ApiAppConstants.orderdetails}?tkn=$token&oid=$oid",
      );
      debugPrint('\x1b[97m Response : $authUserResponse');
      return await authUserResponse['body'];
    } catch (e) {
      CommonMethod().getXSnackBar(
          "Your Token Is Expire", "Please login again", Colors.red);
      Get.off(() => LoginScreen());
      return e.toString();
    }
  }

  Future<void> checkResponse(
    response,
    modelResponse,
  ) async {
    if (response["error_description"] == null ||
        response["error_description"] == 'null') {
      if (response['body']['status'] == 200 ||
          response['body']['status'] == "200") {
        return modelResponse;
        // } else {
        //   showErrorDialog(message: response['body']['message']);
        // }
      } else if (response['body']['status'] == 500 ||
          response['body']['status'] == "500") {
        return modelResponse;
      } else {
        showErrorDialog(message: response['body']['message']);
      }
    }
    // else {
    //   if (response['body']['status'] == 401 ||
    //       response['body']['status'] == '401') {
    //     showErrorDialog(message: response['body']['message']);
    //     Future.delayed(Duration(seconds: 2), () {
    //       // Get.to(LoginScreen());
    //     });
    // }
    else {
      showErrorDialog(message: response['body']['message']);
    }
    // }
  }

  Future<void> checkResponse2(
    response,
  ) async {
    if (response["error_description"] == null ||
        response["error_description"] == 'null') {
      if (response['body']['status'] == 200 ||
          response['body']['status'] == "200") {
        return response['body'];
      } else if (response['body']['status'] == 500 ||
          response['body']['status'] == "500") {
        showErrorDialog(message: response['body']['message']);
        return response['body'];
      } else {
        showErrorDialog(message: response['body']['message']);
      }
    } else {
      showErrorDialog(message: response['body']['message']);
    }
  }

  void showErrorDialog({required String message}) {
    CommonMethod().getXSnackBar("Error", message.toString(), Colors.red);
  }
}
