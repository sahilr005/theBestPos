import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:order/controller/item_controller.dart';
import 'package:order/utils/common_method.dart';
import 'package:order/utils/repository/network_repository.dart';

class ItemMasterScreen extends StatefulWidget {
  const ItemMasterScreen({super.key});

  @override
  State<ItemMasterScreen> createState() => _ItemMasterScreenState();
}

class _ItemMasterScreenState extends State<ItemMasterScreen> {
  ItemController controller = ItemController();
  List itemList = [];

  item(BuildContext context) async {
    var res = await networkRepository.itemApi(context);
    if (res["status"] == "failure") {
      CommonMethod().getXSnackBar('Error', res["status"], Colors.red);
    }
    if (res["items"] != null) {
      itemList = res["items"];
      setState(() {});
    }
  }

  itemUpdate(
      {required BuildContext context, required status, required itemID}) async {
    var res = await networkRepository.itemApi(context,
        itemID: itemID, status: status);
    if (res["status"] == "failure") {
      CommonMethod().getXSnackBar('Error', res["status"], Colors.red);
    }
    if (res["status"] == "success") {
      // ignore: use_build_context_synchronously
      await item(context);
    }
  }

  @override
  void initState() {
    item(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Master"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Card(
                child: DataTable(
                  dataRowHeight: 60,
                  columns: const [
                    DataColumn(label: Text('ItemID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: List<DataRow>.generate(
                    itemList.length,
                    (index) => DataRow(cells: [
                      DataCell(Text(itemList[index]["itemid"].toString())),
                      DataCell(Text(itemList[index]["itemname"].toString())),
                      DataCell(SizedBox(
                        width: 20,
                        child: CupertinoSwitch(
                            value: itemList[index]["active"] == "Y",
                            onChanged: (value) {
                              itemUpdate(
                                  context: context,
                                  status: value ? "Y" : "N",
                                  itemID: itemList[index]["itemid"]);
                            }),
                      )),
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DataCell(InkWell(
  //     onTap: () {
  //       statusDialog(context, controller);
  //     },
  //     child: Text(controller.statusValue))),
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
