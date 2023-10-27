import 'dart:developer';
import 'dart:io';

import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/config/common.dart';
import 'package:order/main.dart';
import 'package:order/view/category/category_master.dart';
import 'package:order/view/daywise/daywise.dart';
import 'package:order/view/eatin/eatin_master.dart';
import 'package:order/view/holiday/holiday.dart';
import 'package:order/view/item/itemmaster.dart';
import 'package:order/view/login/login.dart';
import 'package:order/view/order/orderlist.dart';
import 'package:order/view/reporting/reporting.dart';
import 'package:order/view/settings/settings.dart';
import 'package:order/view/sizebase/sizebase.dart';
import 'package:order/view/toppings/topping_master.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum menuName {
  orderList,
  itemMaster,
  eatIn,
  holidayList,
  sizeBase,
  topping,
  category,
  reporting,
  daywise,
}

class _HomeScreenState extends State<HomeScreen> {
  Color baseColor = const Color(0xFFF2F2F2);

  itemSet() {
    if (box!.get(menuName.orderList.name.toString()) == null) {
      box!.put(menuName.orderList.name.toString(), true);
    }
    if (box!.get(menuName.itemMaster.name.toString()) == null) {
      box!.put(menuName.itemMaster.name, false);
    }
    if (box!.get(menuName.eatIn.name) == null) {
      box!.put(menuName.eatIn.name, false);
    }
    if (box!.get(menuName.holidayList.name) == null) {
      box!.put(menuName.holidayList.name, false);
    }
    if (box!.get(menuName.sizeBase.name) == null) {
      box!.put(menuName.sizeBase.name, true);
    }
    if (box!.get(menuName.topping.name) == null) {
      box!.put(menuName.topping.name, true);
    }
    if (box!.get(menuName.category.name) == null) {
      box!.put(menuName.category.name, true);
    }
    if (box!.get(menuName.reporting.name) == null) {
      box!.put(menuName.reporting.name, false);
    }
    if (box!.get(menuName.daywise.name) == null) {
      box!.put(menuName.daywise.name, false);
    }
    menuGet();
  }

  @override
  void initState() {
    itemSet();
    versionCheck();
    setState(() {});
    super.initState();
  }

  versionCheck() async {
    if (Platform.isIOS) {
      DocumentSnapshot appConfig = await FirebaseFirestore.instance
          .collection("AppConfig")
          .doc("v1Bjv4AI7GgWui1jFJQm")
          .get();
      if (packageInfo != null) {
        if (packageInfo!.version.toString() != await appConfig.get("version")) {
          Future.delayed(Duration.zero, () {
            showUpgradeDialog(context);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              // decoration: BoxDecoration(color: appColor.withOpacity(0.2)),
              child: Image.asset(
                  "assets/fwdposlogo/the-best-POS_final-logo.png",
                  height: Get.height * .3),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                child: ListTile(
                  onTap: () {
                    Get.to(() => SettingsScreen())!.whenComplete(() {
                      menuGet();
                      setState(() {});
                    });
                  },
                  title: Text("Settings"),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Cosmic POS Repo"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.offAll(() => const LoginScreen());
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClayContainer(
                borderRadius: 10000,
                color: baseColor,
                height: 180,
                width: 180,
                depth: 15,
                spread: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    "assets/fwdposlogo/the-best-POS_final-logo.png",
                  ),
                ),
              ),
              height(30),
              const SelectOptions(),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectOptions extends StatefulWidget {
  const SelectOptions({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectOptions> createState() => _SelectOptionsState();
}

class _SelectOptionsState extends State<SelectOptions> {
  @override
  Widget build(BuildContext context) {
    log(menuVal.value.toString());
    return Obx(() => ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            if (menuVal.value[0])
              Card(
                child: ListTile(
                  onTap: () {
                    Get.to(() => OrderListScreen());
                  },
                  title: const Text("Order List"),
                ),
              ),
            if (menuVal.value[1])
              Card(
                child: ListTile(
                  onTap: () {
                    Get.to(() => const ItemMasterScreen());
                  },
                  title: const Text("Item Master"),
                ),
              ),
            if (menuVal.value[8])
              Card(
                child: ListTile(
                  onTap: () {
                    Get.to(() => const DayWiseReportScreen());
                  },
                  title: const Text("Daywise Item "),
                ),
              ),
            if (menuVal.value[2])
              Card(
                child: ListTile(
                  onTap: () {
                    Get.to(() => const EatinScreen());
                  },
                  title: const Text("EatIn "),
                ),
              ),
            if (menuVal.value[3])
              Card(
                child: ListTile(
                  onTap: () {
                    Get.to(() => HolidayMaster());
                  },
                  title: const Text("Holiday Master"),
                ),
              ),
            if (menuVal.value[4])
              Card(
                child: ListTile(
                  onTap: () {
                    Get.to(() => const SizeBaseScreen());
                  },
                  title: const Text("Size Base Setting"),
                ),
              ),
            if (menuVal.value[5])
              Card(
                child: ListTile(
                  onTap: () {
                    Get.to(() => const ToppingMasterScreen());
                  },
                  title: const Text("Topping Master"),
                ),
              ),
            if (menuVal.value[6])
              Card(
                child: ListTile(
                  onTap: () {
                    Get.to(() => const CategoryMasterScreen());
                  },
                  title: const Text("Category Master"),
                ),
              ),
            if (menuVal.value[7])
              Card(
                child: ListTile(
                  onTap: () {
                    Get.to(() => const ReportingScreen());
                  },
                  title: const Text("Reporting"),
                ),
              ),
          ],
        ));
  }
}
