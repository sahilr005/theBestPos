import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:order/config/common.dart';
import 'package:order/utils/api_constants.dart';
import 'package:order/utils/common_method.dart';
import 'package:order/utils/network_dio/network_dio.dart';

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
      final authUserResponse = await NetworkDioHttp.getDioHttpMethod(
        context: context,
        url:
            "${ApiAppConstants.apiEndPoint}${ApiAppConstants.login}?unm=$email&pwd=$password",
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
    try {
      final authUserResponse = await NetworkDioHttp.getDioHttpMethod(
        context: context,
        url:
            "${ApiAppConstants.apiEndPoint}${ApiAppConstants.orderlist}?tkn=$token&fdt=$fromDate&tdt=$toDate",
      );
      debugPrint('\x1b[97m Response : $authUserResponse');
      return await authUserResponse['body'];
    } catch (e) {
      CommonMethod().getXSnackBar("Error", e.toString(), Colors.red);
      return e.toString();
    }
  }

  Future categoryApi(context, {catid, off}) async {
    final String? token = box!.get('token');
    try {
      final authUserResponse = await NetworkDioHttp.getDioHttpMethod(
        context: context,
        url: catid != null
            ? "${ApiAppConstants.apiEndPoint}${ApiAppConstants.category}?tkn=$token&catid=$catid=&act=Update&active=$off"
            : "${ApiAppConstants.apiEndPoint}${ApiAppConstants.category}?tkn=$token&act=Show",
      );
      debugPrint('\x1b[97m Response : $authUserResponse');
      return await authUserResponse['body'];
    } catch (e) {
      CommonMethod().getXSnackBar("Error", e.toString(), Colors.red);
      return e.toString();
    }
  }

  Future toppingApi(context, {name, off}) async {
    final String? token = box!.get('token');
    try {
      final authUserResponse = await NetworkDioHttp.getDioHttpMethod(
        context: context,
        url: name != null
            ? "${ApiAppConstants.apiEndPoint}${ApiAppConstants.topping}?tkn=$token&act=Update&name=$name&active=$off"
            : "${ApiAppConstants.apiEndPoint}${ApiAppConstants.topping}?tkn=$token&act=Show",
      );
      debugPrint('\x1b[97m Response : $authUserResponse');
      return await authUserResponse['body'];
    } catch (e) {
      CommonMethod().getXSnackBar("Error", e.toString(), Colors.red);
      return e.toString();
    }
  }

  Future itemApi(context, {itemID, status}) async {
    final String? token = box!.get('token');
    try {
      final authUserResponse = await NetworkDioHttp.getDioHttpMethod(
        context: context,
        url: itemID != null
            ? "${ApiAppConstants.apiEndPoint}${ApiAppConstants.item}?tkn=$token&itemid=$itemID&act=Update&active=$status"
            : "${ApiAppConstants.apiEndPoint}${ApiAppConstants.item}?tkn=$token&act=Show",
      );
      debugPrint('\x1b[97m Response : $authUserResponse');
      return await authUserResponse['body'];
    } catch (e) {
      CommonMethod().getXSnackBar("Error", e.toString(), Colors.red);
      return e.toString();
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
      CommonMethod().getXSnackBar("Error", e.toString(), Colors.red);
      return e.toString();
    }
  }

  Future sizeUpdateApi(context, {required data}) async {
    final String? token = box!.get('token');
    try {
      final authUserResponse = await NetworkDioHttp.postDioHttpMethod(
          context: context,
          url: "${ApiAppConstants.apiEndPoint}${ApiAppConstants.setSizebase}" +
              "?tkn=$token",
          data: data);
      debugPrint('\x1b[97m Response : $authUserResponse');
      return await authUserResponse['body'];
    } catch (e) {
      CommonMethod().getXSnackBar("Error", e.toString(), Colors.red);
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
      CommonMethod().getXSnackBar("Error", e.toString(), Colors.red);
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
