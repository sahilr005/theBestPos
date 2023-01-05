import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/controller/sizebase_controller.dart';

class SizeBaseScreen extends StatelessWidget {
  const SizeBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Size Base"), centerTitle: true),
      body: GetBuilder<SizeBaseController>(
          init: SizeBaseController(),
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
                        const DataCell(Text('Small')),
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
