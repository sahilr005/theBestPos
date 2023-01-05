import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/controller/category_controller.dart';

class CategoryMasterScreen extends StatelessWidget {
  const CategoryMasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Master"),
        centerTitle: true,
      ),
      body: GetBuilder<CategoryController>(
          init: CategoryController(),
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Center(
                child: Card(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ItemID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: List<DataRow>.generate(
                      3,
                      (index) => DataRow(cells: [
                        DataCell(Text(index.toString())),
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
