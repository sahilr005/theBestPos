import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:order/utils/common_method.dart';

NetworkRepository networkRepository = NetworkRepository();

class NetworkRepository {
  static final NetworkRepository _networkRepository =
      NetworkRepository._internal();
  static final dataStorage = GetStorage();

  factory NetworkRepository() {
    return _networkRepository;
  }
  NetworkRepository._internal();

  FocusNode searchFocus = FocusNode();

  // userLogin(context, authUserData) async {
  //   try {
  //     final authUserResponse = await NetworkDioHttp.postDioHttpMethod(
  //       context: context,
  //       url: ApiAppConstants.apiEndPoint + ApiAppConstants.login,
  //       data: authUserData,
  //     );
  //     debugPrint('\x1b[97m Response : $authUserResponse');
  //     return checkResponse(
  //         authUserResponse, LoginModel.fromJson(authUserResponse['body']));
  //   } catch (e) {
  //     CommonMethod().getXSnackBar("Error", e.toString(), Colors.red);
  //   }
  // }

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
