import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/utils/app_constants.dart';
import 'package:order/utils/network_dio/network_dio.dart';
import 'package:order/view/login/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NetworkDioHttp.setDynamicHeader(endPoint: ApiAppConstants.apiEndPoint);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.pink,
        fontFamily: "Cera Pro"
      ),
      home: const LoginScreen(),
    );
  }
}
