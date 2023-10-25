import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/config/common.dart';
import 'package:order/view/home/home.dart';

RxList menuVal = [].obs;

menuGet() async {
  menuVal.value.clear();
  menuVal.add(box!.get(menuName.orderList.name) ?? true);
  menuVal.add(box!.get(menuName.itemMaster.name) ?? false);
  menuVal.add(box!.get(menuName.eatIn.name) ?? false);
  menuVal.add(box!.get(menuName.holidayList.name) ?? false);
  menuVal.add(box!.get(menuName.sizeBase.name) ?? true);
  menuVal.add(box!.get(menuName.topping.name) ?? true);
  menuVal.add(box!.get(menuName.category.name) ?? true);
  menuVal.add(box!.get(menuName.reporting.name) ?? false);
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Show/Hide Menu"),
            Card(
              child: ListTile(
                title: Text("Order List"),
                trailing: CupertinoSwitch(
                    value: box!.get(menuName.orderList.name),
                    onChanged: (a) {
                      box!.put(menuName.orderList.name, a);
                      setState(() {});
                    }),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Item Master"),
                trailing: CupertinoSwitch(
                    value: box!.get(menuName.itemMaster.name),
                    onChanged: (a) {
                      box!.put(menuName.itemMaster.name, a);
                      setState(() {});
                    }),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Eat In"),
                trailing: CupertinoSwitch(
                    value: box!.get(menuName.eatIn.name),
                    onChanged: (a) {
                      box!.put(menuName.eatIn.name, a);
                      setState(() {});
                    }),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Holiday Master"),
                trailing: CupertinoSwitch(
                    value: box!.get(menuName.holidayList.name),
                    onChanged: (a) {
                      box!.put(menuName.holidayList.name, a);
                      setState(() {});
                    }),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Size Base Settings"),
                trailing: CupertinoSwitch(
                    value: box!.get(menuName.sizeBase.name),
                    onChanged: (a) {
                      box!.put(menuName.sizeBase.name, a);
                      setState(() {});
                    }),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Topping Master"),
                trailing: CupertinoSwitch(
                    value: box!.get(menuName.topping.name),
                    onChanged: (a) {
                      box!.put(menuName.topping.name, a);
                      setState(() {});
                    }),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Category Master"),
                trailing: CupertinoSwitch(
                    value: box!.get(menuName.category.name),
                    onChanged: (a) {
                      box!.put(menuName.category.name, a);
                      setState(() {});
                    }),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Reporting Master"),
                trailing: CupertinoSwitch(
                    value: box!.get(menuName.reporting.name),
                    onChanged: (a) {
                      box!.put(menuName.reporting.name, a);
                      setState(() {});
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
