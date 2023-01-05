import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/config/common.dart';
import 'package:order/view/category/category_master.dart';
import 'package:order/view/item/itemmaster.dart';
import 'package:order/view/login/login.dart';
import 'package:order/view/order/orderlist.dart';
import 'package:order/view/sizebase/sizebase.dart';
import 'package:order/view/toppings/topping_master.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: appColor.withOpacity(0.2)),
                child: Image.asset("assets/logo.png", height: Get.height * .3),
              ),
              const SelectOptions(),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text("App Name"),
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/logo.png", height: Get.height * .3),
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
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Card(
          child: ListTile(
            onTap: () {
              Get.to(() => const OrderListScreen());
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
      ],
    );
  }
}