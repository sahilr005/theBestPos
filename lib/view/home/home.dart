import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/config/common.dart';
import 'package:order/view/category/category_master.dart';
import 'package:order/view/item/itemmaster.dart';
import 'package:order/view/login/login.dart';
import 'package:order/view/order/orderlist.dart';
import 'package:order/view/reporting/reporting.dart';
import 'package:order/view/sizebase/sizebase.dart';
import 'package:order/view/toppings/topping_master.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color baseColor = const Color(0xFFF2F2F2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                // decoration: BoxDecoration(color: appColor.withOpacity(0.2)),
                child: Image.asset("assets/fwdposlogo/the-best-POS_final-logo.png", height: Get.height * .3),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SelectOptions(),
              ),
            ],
          ),
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

class SelectOptions extends StatelessWidget {
  const SelectOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Card(
          child: ListTile(
            onTap: () {
              Get.to(() => OrderListScreen());
            },
            title: const Text("Order List"),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () {
              Get.to(() => const ItemMasterScreen());
            },
            title: const Text("Item Master"),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () {
              Get.to(() => const SizeBaseScreen());
            },
            title: const Text("Size Base Setting"),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () {
              Get.to(() => const ToppingMasterScreen());
            },
            title: const Text("Topping Master"),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () {
              Get.to(() => const CategoryMasterScreen());
            },
            title: const Text("Category Master"),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () {
              Get.to(() => const ReportingScreen());
            },
            title: const Text("Reporting"),
          ),
        ),
      ],
    );
  }
}
