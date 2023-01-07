import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/config/common.dart';
import 'package:order/controller/sizebase_controller.dart';
import 'package:order/utils/common_method.dart';
import 'package:order/utils/repository/network_repository.dart';

class SizeBaseScreen extends StatefulWidget {
  const SizeBaseScreen({super.key});

  @override
  State<SizeBaseScreen> createState() => _SizeBaseScreenState();
}

class _SizeBaseScreenState extends State<SizeBaseScreen> {
  final String? token = box!.get('token');
  List sizeList = [];
  List<Map> dataMap = [];

  sizesGet(BuildContext context) async {
    var res = await networkRepository.sizeApi(context);
    dataMap = [];
    if (res["status"] == "failure") {
      CommonMethod().getXSnackBar('Error', res["status"], Colors.red);
    }
    if (res["sizes"] != null) {
      sizeList = res["sizes"];
      for (var index = 0; index < sizeList.length; index++) {
        for (var i = 0; i < sizeList[index]["bases"].length; i++) {
          if (sizeList[index]["bases"][i]["is_active"] == "1") {
            dataMap.add({
              "szid": sizeList[index]["szid"],
              "bid": sizeList[index]["bases"][i]["bid"],
            });
       
          }
        }
      }
      setState(() {});
    }
  }

  sizeUpdate(BuildContext context) async {
    final String? token = box!.get('token');
    var res = await networkRepository.sizeUpdateApi(context,
        data: {"tkn": token.toString(), "sbarr": dataMap});
    if (res["status"] == "failure") {
      CommonMethod().getXSnackBar('Error', res["status"], Colors.red);
    }
    if (res["status"] == "success") {
      sizesGet(context);
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () => sizesGet(context));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Size Base"), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GetBuilder<SizeBaseController>(
                init: SizeBaseController(),
                builder: (controller) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: ListView.builder(
                          itemCount: sizeList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: DataTable(
                                columns: [
                                  DataColumn(
                                      label: Text(sizeList[index]["szname"])),
                                  const DataColumn(label: Text("")),
                                  const DataColumn(label: Text("")),
                                ],
                                rows: List<DataRow>.generate(
                                    sizeList[index]["bases"].length, (ind) {
                                  return DataRow(cells: [
                                    DataCell(Text(
                                        sizeList[index]["bases"][ind]["bid"])),
                                    DataCell(Text(sizeList[index]["bases"][ind]
                                        ["bname"])),
                                    DataCell(Row(
                                      children: [
                                        Text(sizeList[index]["bases"][ind]
                                                    ["is_active"] ==
                                                "1"
                                            ? "ON "
                                            : "OFF "),
                                        CupertinoSwitch(
                                            // value:
                                            //     !dataMap.every((Map element) {
                                            //   log("sssssss ---- " +
                                            //       element.toString());
                                            //   bool? ret;
                                            //   element.forEach((key, value) {
                                            //     if (key == "szid" &&
                                            //         value ==
                                            //             sizeList[index]
                                            //                 ["szid"]) {
                                            //       ret = true;
                                            //     } else {
                                            //       ret = false;
                                            //     }
                                            //   });
                                            //   return ret ?? false;
                                            // }),
                                            value: sizeList[index]["bases"][ind]
                                                    ["is_active"] ==
                                                "1",
                                            onChanged: (value) {
                                              if (!value) {
                                                dataMap.removeWhere((element) {
                                                  return element.toString() ==
                                                      {
                                                        "szid": sizeList[index]
                                                            ["szid"],
                                                        "bid": sizeList[index]
                                                                ["bases"][ind]
                                                            ["bid"],
                                                      }.toString();
                                                });

                                                setState(() {});
                                                sizeUpdate(context);
                                              }

                                              if (value) {
                                                dataMap.add({
                                                  "szid": sizeList[index]
                                                      ["szid"],
                                                  "bid": sizeList[index]
                                                      ["bases"][ind]["bid"],
                                                });

                                                setState(() {});
                                                sizeUpdate(context);
                                              }
                                            }),
                                      ],
                                    )),
                                  ]);
                                }),
                              ),
                            );
                          }),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
