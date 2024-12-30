import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:hive_flutter/hive_flutter.dart';
import 'package:order/config/common.dart';
import 'package:order/gemini.dart';
import 'package:order/utils/api_constants.dart';
import 'package:order/utils/network_dio/network_dio.dart';
import 'package:order/view/home/home.dart';
import 'package:order/view/login/login.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

import 'firebase_options.dart';

PackageInfo? packageInfo;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  packageInfo = await PackageInfo.fromPlatform();

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
      builder: EasyLoading.init(),
      theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.pink,
          fontFamily: "Cera Pro"),
      home: 
      UpgradeAlert(
          upgrader: Upgrader(),
          child: token != null ? const HomeScreen() : const LoginScreen()),
    );
  }
}

Future<void> showUpgradeDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('New Version Available'),
        content: Text(
            'A new version of the app is available. Please update to continue using the app.'),
        actions: <Widget>[
          // TextButton(
          //   child: const Text('Ignore'),
          //   onPressed: () async{
          // Get.back();
          //   },
          // ),
          TextButton(
            child: Text('Update'),
            onPressed: () async {
              var url = Platform.isAndroid
                  ? "https://play.google.com/store/apps/details?id=com.best.pos"
                  : 'https://testflight.apple.com/join/Zix4aBI2'; // Replace with your app's App Store URL
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              } else {}
            },
          ),
        ],
      );
    },
  );
}
