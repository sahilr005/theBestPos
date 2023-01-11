import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:order/config/common.dart';
import 'package:order/controller/reporting_controller.dart';
import 'package:order/utils/nodata.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportingScreen extends StatefulWidget {
  const ReportingScreen({super.key});

  @override
  State<ReportingScreen> createState() => _ReportingScreenState();
}

class _ReportingScreenState extends State<ReportingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reporting")),
      body: GetBuilder<ReportingController>(
          init: ReportingController(),
          initState: (_) {
            ReportingController().reportingAPI(context);
          },
          builder: (controller) {
            Map map = {};

            return Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: Text(
                          "From : ${DateFormat.yMMMMEEEEd().format(controller.fromDate)}",
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          controller.fromDate = (await showDatePicker(
                            context: context,
                            initialDate: controller.fromDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000),
                          ))!;
                          controller.reportingAPI(context);
                          controller.update();
                        },
                      ),
                    ),
                    height(10),
                    Card(
                      child: ListTile(
                        title: Text(
                          "To : ${DateFormat.yMMMMEEEEd().format(controller.toDate)}",
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          controller.toDate = (await showDatePicker(
                            context: context,
                            initialDate: controller.fromDate,
                            firstDate: controller.fromDate,
                            lastDate: DateTime(3000),
                          ))!;
                          controller.reportingAPI(context);
                          controller.update();
                        },
                      ),
                    ),
                    height(10),
                    if (controller.reportingData.isNotEmpty)
                      Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: () {
                                showDialog(
                                    builder: (context) => CupertinoAlertDialog(
                                          title: Column(
                                            children: const <Widget>[
                                              Text("Filter "),
                                            ],
                                          ),
                                          content: Material(
                                            color: Colors.transparent,
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  tileColor: Colors.transparent,
                                                  title:
                                                      const Text("By Category"),
                                                  dense: true,
                                                  onTap: () {
                                                    controller.sortValue = 0;
                                                    controller.update();
                                                    Get.back();
                                                  },
                                                ),
                                                const Divider(height: 2),
                                                ListTile(
                                                  tileColor: Colors.transparent,
                                                  title:
                                                      const Text("By Product"),
                                                  dense: true,
                                                  onTap: () {
                                                    controller.sortValue = 1;
                                                    controller.update();
                                                    Get.back();
                                                  },
                                                ),
                                                const Divider(height: 2),
                                                ListTile(
                                                  tileColor: Colors.transparent,
                                                  title: const Text("By Sales"),
                                                  dense: true,
                                                  onTap: () {
                                                    controller.sortValue = 2;
                                                    controller.update();
                                                    Get.back();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            CupertinoDialogAction(
                                              child: const Text("CANCEL"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                    context: context);
                              },
                              icon: const Icon(Icons.sort))),
                    SfCircularChart(
                      series: <CircularSeries>[
                        // Render pie chart
                        PieSeries<dynamic, String>(
                          dataSource: List.generate(
                              controller.categorySet.length, (ind) {
                            int res = 0;
                            List amcl = [];
                            double sum = 0.0;
                            if (controller.sortValue == 0) {
                              res = controller.categoryList
                                  .map((element) => element ==
                                          controller.categorySet.toList()[ind]
                                      ? 1
                                      : 0)
                                  .reduce((value, element) => value + element);
                              amcl = controller
                                  .cal()[controller.categorySet
                                      .toList()[ind]
                                      .toString()]
                                  .toString()
                                  .split(",");
                              sum = amcl.fold<double>(
                                  0,
                                  (prev, value) =>
                                      prev +
                                      (double.tryParse(value ?? '0') ?? 0));
                            } else {
                              res = controller.itemList
                                  .map((element) => element ==
                                          controller.itemSet.toList()[ind]
                                      ? 1
                                      : 0)
                                  .reduce((value, element) => value + element);

                              amcl = controller
                                  .cal()[controller.itemSet
                                      .toList()[ind]
                                      .toString()]
                                  .toString()
                                  .split(",");
                              sum = amcl.fold<double>(
                                  0,
                                  (prev, value) =>
                                      prev +
                                      (double.tryParse(value ?? '0') ?? 0));
                            }
                            return {
                              "x": controller.itemSet.toList()[ind].toString(),
                              "y": controller.sortValue == 0
                                  ? ((res / controller.categoryList.length) *
                                          100)
                                      .round()
                                  : ((res / controller.itemList.length) * 100)
                                      .round(),
                              "color": Colors.green
                            };
                          }),
                          xValueMapper: (data, _) => data["x"],
                          yValueMapper: (data, _) => data["y"],
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                          ),
                        ),
                      ],
                    ),
                    if (controller.reportingData.isNotEmpty)
                      ListTile(
                          title: const Text("Total Sales : "),
                          trailing: Text(controller.totalAmount
                              .toPrecision(2)
                              .toString())),
                    height(10),
                    if (controller.reportingData.isEmpty) NoData(),
                    ListView.builder(
                      itemCount: controller.sortValue == 0
                          ? controller.categorySet.length
                          : controller.itemSet.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        int res = 0;
                        List amcl = [];
                        double sum = 0.0;
                        if (controller.sortValue == 0) {
                          res = controller.categoryList
                              .map((element) => element ==
                                      controller.categorySet.toList()[index]
                                  ? 1
                                  : 0)
                              .reduce((value, element) => value + element);

                          amcl = controller
                              .cal()[controller.categorySet
                                  .toList()[index]
                                  .toString()]
                              .toString()
                              .split(",");
                          sum = amcl.fold<double>(
                              0,
                              (prev, value) =>
                                  prev + (double.tryParse(value ?? '0') ?? 0));
                        } else {
                          res = controller.itemList
                              .map((element) =>
                                  element == controller.itemSet.toList()[index]
                                      ? 1
                                      : 0)
                              .reduce((value, element) => value + element);

                          amcl = controller
                              .cal()[
                                  controller.itemSet.toList()[index].toString()]
                              .toString()
                              .split(",");
                          sum = amcl.fold<double>(
                              0,
                              (prev, value) =>
                                  prev + (double.tryParse(value ?? '0') ?? 0));
                        }
                        return Card(
                            color: Colors.blue.shade100,
                            child: ExpansionTile(
                              title: Text(
                                controller.sortValue == 0
                                    ? controller.categorySet
                                        .toList()[index]
                                        .toString()
                                    : controller.itemSet
                                        .toList()[index]
                                        .toString(),
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: const Text("Qty. Sold"),
                                  trailing: Text(res.toString()),
                                  dense: true,
                                ),
                                ListTile(
                                  title: const Text("% of Qty."),
                                  trailing: controller.sortValue == 0
                                      ? Text(
                                          "${((res / controller.categoryList.length) * 100).toPrecision(2)}%")
                                      : Text(
                                          "${((res / controller.itemList.length) * 100).toPrecision(2)}%"),
                                  dense: true,
                                ),
                                ListTile(
                                  title: const Text("Amount"),
                                  trailing: Text("\$${sum.toPrecision(2)}"),
                                  dense: true,
                                ),
                                ListTile(
                                  title: const Text("	% of Sales"),
                                  trailing: Text(
                                      "${((sum / controller.totalAmount) * 100).toPrecision(2)}%"),
                                  dense: true,
                                ),
                              ],
                            ));
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
