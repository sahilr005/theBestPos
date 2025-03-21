import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/config/common.dart';
import 'package:order/utils/api_constants.dart';
import 'package:order/utils/common_method.dart';
import 'package:order/utils/network_dio/network_dio.dart';
import 'package:order/utils/repository/network_repository.dart';
import 'package:order/view/home/home.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController(
    text: box!.get("email") ?? "",
  );
  TextEditingController passwordController = TextEditingController(
    text: box!.get("password") ?? "",
  );
  login(context) async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // if (emailController.text == "sahil@gmail.com") {
      //   Get.offAll(() => MyHomePageGEmini(title: "Gemini Ai Chat bot"));
      //   return;
      // }
      var res = await networkRepository.userLogin(
          context, emailController.text.trim(), passwordController.text.trim());
      log(res.toString());
      if (res["status"] == "success") {
        box!.put("token", res["token"]);
        box!.put("email", emailController.text.trim());
        box!.put("password", passwordController.text.trim());
        NetworkDioHttp.setDynamicHeader(endPoint: ApiAppConstants.apiEndPoint);
        update();
        Get.offAll(() => const HomeScreen());
      } else {
        print("===== $res");
        CommonMethod().getXSnackBar('Error', res["status"]!, Colors.red);
      }
    } else {
      Get.snackbar("Fill the details", "Email & Password is required");
    }
  }
}
