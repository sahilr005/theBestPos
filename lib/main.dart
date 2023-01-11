import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/config/common.dart';
import 'package:order/utils/api_constants.dart';
import 'package:order/utils/network_dio/network_dio.dart';
import 'package:order/view/home/home.dart';
import 'package:order/view/login/login.dart';
// ignore: depend_on_referenced_packages
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  box = await Hive.openBox('Box');
  NetworkDioHttp.setDynamicHeader(endPoint: ApiAppConstants.apiEndPoint);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String? token = box!.get('token');
    return GetMaterialApp(
        title: 'Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.pink,
            fontFamily: "Cera Pro"),
        home: token != null ? const HomeScreen() : const LoginScreen());
  }
}
