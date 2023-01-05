import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:order/controller/item_controller.dart';

class ItemMasterScreen extends StatelessWidget {
  const ItemMasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Master"),
        centerTitle: true,
      ),
      body: GetBuilder<ItemController>(
          init: ItemController(),
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: SizedBox(
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Card(
                      child: DataTable(
                        columns: const [
                          DataColumn(
                            label: Text('ItemID'),
                          ),
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
                            const DataCell(Text('MCm173')),
                            const DataCell(Text('Mango ')),
                            DataCell(InkWell(
                                onTap: () {
                                  statusDialog(context, controller);
                                },
                                child: Text(controller.statusValue))),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<dynamic> statusDialog(
      BuildContext context, ItemController controller) {
    return showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: const Text("Item Status"),
              content: SizedBox(
                height: 230,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.items.length,
                  itemBuilder: (context, ind) {
                    return GestureDetector(
                      onTap: () async {
                        if (ind != 2) {
                          controller.statusValue = controller.items[ind];
                          controller.update();
                          Get.back();
                        } else {
                          controller.datePick = (await showDatePicker(
                              context: _,
                              initialDate: controller.datePick,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(3000)))!;
                          controller.statusValue =
                              DateFormat.Md().format(controller.datePick);
                          controller.update();
                          Get.back();
                        }
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(controller.items[ind]),
                              if (controller.statusValue ==
                                  controller.items[ind])
                                const Icon(Icons.check),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: <Widget>[
                // CupertinoDialogAction(
                //   textStyle:
                //       TextStyle(color: Colors.green),
                //   child: Text("UPDATE"),
                //   onPressed: () {
                //     Navigator.of(_).pop();
                //   },
                // ),
                CupertinoDialogAction(
                  child: const Text("CANCEL"),
                  onPressed: () {
                    Navigator.of(_).pop();
                  },
                ),
              ],
            ));
  }
}
