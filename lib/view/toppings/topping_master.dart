import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/controller/topping.dart';

class ToppingMasterScreen extends StatelessWidget {
  const ToppingMasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Topping Master"),
      ),
      body: GetBuilder<ToppingController>(
          init: ToppingController(),
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Card(
                  child: DataTable(
                    columns: const [
                      DataColumn(
                        label: Text('Name'),
                      ),
                      DataColumn(
                        label: Text('Status'),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                      3,
                      (index) => DataRow(cells: [
                        const DataCell(Text('Large')),
                        DataCell(Row(
                          children: [
                            Text(controller.active ? "ON " : "OFF "),
                            CupertinoSwitch(
                                value: controller.active,
                                onChanged: (value) {
                                  controller.active = value;
                                  controller.update();
                                })
                          ],
                        )),
                      ]),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
