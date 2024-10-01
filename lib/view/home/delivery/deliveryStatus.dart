import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/utils/nodata.dart';
import 'package:order/utils/repository/network_repository.dart';

class DeliveryMasterScreen extends StatefulWidget {
  const DeliveryMasterScreen({super.key});

  @override
  State<DeliveryMasterScreen> createState() => _DeliveryMasterScreenState();
}

class _DeliveryMasterScreenState extends State<DeliveryMasterScreen> {
  List categoryData = [];
  category(context) async {
    var res = await networkRepository.deliveryApi(context);
    if (res["delivery_type"] != null) {
      categoryData = res["delivery_type"];
    } else {
      // CommonMethod().getXSnackBar('Error', res["status"], Colors.red);
    }
    setState(() {});
  }

  deliveryStatusUpdate(context, {required String catid, status}) async {
    await networkRepository.deliveryTypeChangeApi(context,
        id: catid, cstatus: status);
    category(context);
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () => category(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Master"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: categoryData.isEmpty
            ? NoData()
            : ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: Card(
                      child: SizedBox(
                        width: Get.width,
                        child: DataTable(
                          dataRowHeight: 60,
                          columns: const [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Status')),
                          ],
                          rows: List<DataRow>.generate(
                            categoryData.length,
                            (index) => DataRow(cells: [
                              DataCell(Text(categoryData[index]["dtxt"])),
                              DataCell(CupertinoSwitch(
                                  value: categoryData[index]["cstatus"] == "1",
                                  onChanged: (value) {
                                    log(categoryData[index].toString());
                                    deliveryStatusUpdate(
                                      context,
                                      catid: categoryData[index]["dtid"],
                                      status: value ? "1" : "0",
                                    );
                                  })),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
