import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:order/config/common.dart';
import 'package:order/controller/reporting_controller.dart';
import 'package:order/utils/nodata.dart';
import 'package:order/utils/process_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportingScreen extends StatefulWidget {
  const ReportingScreen({super.key});

  @override
  State<ReportingScreen> createState() => _ReportingScreenState();
}

class _ReportingScreenState extends State<ReportingScreen> {
  ReportingController controller = ReportingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      controller.shopNameGet(context).then((value) =>
          {controller.reportingAPI(context).then((value) => setState(() {}))});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reporting")),
      body: GetBuilder<ReportingController>(
          init: ReportingController(),
          initState: (_) {
            // ReportingController().reportingAPI(context);
          },
          builder: (roller) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    shopSelect(context),
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
                          // ignore: use_build_context_synchronously
                          controller
                              .reportingAPI(context)
                              .then((value) => setState(() {}));
                          controller.update();
                        },
                      ),
                    ),
                    height(10),
                    if (controller.reportingData.isNotEmpty)
                      Align(
                          alignment: Alignment.centerRight,
                          child: ListTile(
                            dense: true,
                            title: Text(
                                controller.sortValue == 0
                                    ? "Category"
                                    : controller.sortValue == 1
                                        ? "Product"
                                        : "Payment",
                                style: const TextStyle(
                                  color: Colors.pink,
                                  fontSize: 14,
                                )),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    paymentDialog(controller, context);
                                  },
                                  child: Row(
                                    children: [
                                      if (controller.sortValue == 2)
                                        Text(controller.paymentMode == 0
                                            ? "All"
                                            : controller.paymentMode == 1
                                                ? "Cash"
                                                : "eftpos"),
                                      const Icon(Icons.arrow_drop_down)
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      chartDialog(controller, context);
                                    },
                                    icon: const Icon(Icons.sort)),
                              ],
                            ),
                          )),
                    if (controller.sortValue == 2 &&
                        controller.paymentMode == 2)
                      eftposDataList(),
                    if (controller.sortValue == 2 &&
                        controller.paymentMode == 1)
                      cashDataList(),
                    if (controller.sortValue == 2 &&
                        controller.paymentMode == 0)
                      allPaymentList(),
                    if (controller.reportingData.isNotEmpty &&
                        controller.sortValue != 2)
                      chartShow(),
                    height(10),
                    if (controller.reportingData.isEmpty) NoData(),
                    if (controller.sortValue != 2) analysisItem(),
                  ],
                ),
              ),
            );
          }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.sortValue == 2)
              Card(
                color: Colors.green.shade50,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Table(
                    border: TableBorder.all(
                        color: Colors.black,
                        style: BorderStyle.none,
                        width: 0.5),
                    children: [
                      TableRow(children: [
                        Column(children: const []),
                        Column(children: const [
                          Text('Cash', style: TextStyle(fontSize: 16.0))
                        ]),
                        Column(children: const [
                          Text('Eftpos', style: TextStyle(fontSize: 16.0))
                        ]),
                        Column(children: const [
                          Text('Total', style: TextStyle(fontSize: 16.0))
                        ]),
                      ]),
                      TableRow(children: [
                        Column(children: const [Text('Order')]),
                        Column(children: [
                          Text(controller.orderCal()[3].length.toString())
                        ]),
                        Column(children: [
                          Text(
                              "${controller.orderStatus.length - controller.orderCal()[3].length}")
                        ]),
                        Column(children: [
                          Text(controller.orderList.length.toString())
                        ]),
                      ]),
                      TableRow(children: [
                        Column(
                          children: const [Text('Amount')],
                        ),
                        Column(
                          children: [Text(controller.orderCal()[4].toString())],
                        ),
                        Column(
                          children: [
                            Text((controller.totalAmount -
                                    controller.orderCal()[4])
                                .toPrecision(2)
                                .toString())
                          ],
                        ),
                        Column(
                          children: [
                            Text(controller.totalAmount
                                .toPrecision(2)
                                .toString())
                          ],
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            if (controller.reportingData.isNotEmpty &&
                controller.sortValue != 2)
              ListTile(
                  dense: true,
                  title: const Text("Total Sales : "),
                  trailing: Text(
                    controller.totalAmount.toPrecision(2).toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  )),
            if (controller.reportingData.isNotEmpty &&
                controller.sortValue != 2)
              ListTile(
                dense: true,
                title: Text(
                    controller.sortValue != 2 ? "Total Qty : " : "Total Order"),
                trailing: Text(
                  controller.sortValue == 0
                      ? controller.categoryList.length.toString()
                      : controller.sortValue == 1
                          ? controller.itemList.length.toString()
                          : controller.orderList.length.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  SfCircularChart chartShow() {
    return SfCircularChart(
      series: <CircularSeries>[
        // Render pie chart
        PieSeries<dynamic, String>(
          dataSource: List.generate(controller.categorySet.length, (ind) {
            int res = 0;
            List amcl = [];
            double sum = 0.0;
            if (controller.sortValue == 0) {
              res = controller.categoryList
                  .map((element) =>
                      element == controller.categorySet.toList()[ind] ? 1 : 0)
                  .reduce((value, element) => value + element);
              amcl = controller
                  .cal()[controller.categorySet.toList()[ind].toString()]
                  .toString()
                  .split(",");
              sum = amcl.fold<double>(0,
                  (prev, value) => prev + (double.tryParse(value ?? '0') ?? 0));
            } else {
              res = controller.itemList
                  .map((element) =>
                      element == controller.itemSet.toList()[ind] ? 1 : 0)
                  .reduce((value, element) => value + element);

              amcl = controller
                  .itemCal()[controller.itemSet.toList()[ind].toString()]
                  .toString()
                  .split(",");
              sum = amcl.fold<double>(0,
                  (prev, value) => prev + (double.tryParse(value ?? '0') ?? 0));
            }
            return {
              "x": controller.itemSet.toList()[ind].toString(),
              "y": controller.sortValue == 0
                  ? ((res / controller.categoryList.length) * 100).round()
                  : ((res / controller.itemList.length) * 100).round(),
              "color": Colors.green
            };
          }),
          xValueMapper: (data, _) => data["x"],
          yValueMapper: (data, _) => data["y"],
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            builder: (data, point, series, pointIndex, seriesIndex) {
              return Text(
                "${data["x"]} ${data["y"]}%",
                style: const TextStyle(fontSize: 12),
              );
            },
          ),
        ),
      ],
    );
  }

  ListView allPaymentList() {
    return ListView.builder(
      itemCount: controller.orderSet.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        int res = 0;
        List amcl = [];
        List status = [];
        List item = [];
        double sum = 0.0;

        res = controller.orderList
            .map((element) =>
                element == controller.orderSet.toList()[index] ? 1 : 0)
            .reduce((value, element) => value + element);

        amcl = controller
            .orderCal()[0][controller.orderSet.toList()[index].toString()]
            .toString()
            .split(",");
        sum = amcl.fold<double>(
            0, (prev, value) => prev + (double.tryParse(value ?? '0') ?? 0));
        status = controller
            .orderCal()[1][controller.orderSet.toList()[index].toString()]
            .toString()
            .split(",");
        item = controller
            .orderCal()[2][controller.orderSet.toList()[index].toString()]
            .toString()
            .split(",");
        return Card(
          color: Colors.blue.shade100,
          child: ExpansionTile(
            title: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(
                List.generate(status.length,
                        (indd) => status[indd] == "3" ? "Eftpos" : "Cash")
                    .toString()
                    .replaceAll("]", "")
                    .replaceAll("[", ""),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(controller.orderSet.toList()[index].toString()),
              trailing: Text(sum.toPrecision(2).toString()),
            ),
            children: [
              ListView.builder(
                itemCount: item.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, itemIndex) {
                  try {
                    return ListTile(
                      title: Text(item[itemIndex].toString()),
                      trailing: Text(amcl[itemIndex].toString()),
                      dense: true,
                    );
                  } catch (e) {
                    return ListTile(
                      title: Text(item[itemIndex].toString()),
                      trailing: Text("".toString()),
                      dense: true,
                    );
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  ListView cashDataList() {
    return ListView.builder(
      itemCount: controller.cashSet.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        int res = 0;
        List amcl = [];

        List item = [];
        double sum = 0.0;

        res = controller.orderList
            .map((element) =>
                element == controller.cashSet.toList()[index] ? 1 : 0)
            .reduce((value, element) => value + element);

        amcl = controller
            .orderCal()[0][controller.cashSet.toList()[index].toString()]
            .toString()
            .split(",");
        sum = amcl.fold<double>(
            0, (prev, value) => prev + (double.tryParse(value ?? '0') ?? 0));

        item = controller
            .orderCal()[2][controller.cashSet.toList()[index].toString()]
            .toString()
            .split(",");

        return Card(
          color: Colors.blue.shade100,
          child: ExpansionTile(
            title: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "Cash",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(controller.cashSet.toList()[index].toString()),
              trailing: Text(sum.toPrecision(2).toString()),
            ),
            children: [
              ListView.builder(
                itemCount: item.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, itemIndex) {
                  try {
                    return ListTile(
                      title: Text(item[itemIndex].toString()),
                      trailing: Text(amcl[itemIndex].toString()),
                      dense: true,
                    );
                  } catch (e) {
                    return ListTile(
                      title: Text(item[itemIndex].toString()),
                      trailing: Text("".toString()),
                      dense: true,
                    );
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  ListView eftposDataList() {
    return ListView.builder(
      itemCount: controller.eftpoSet.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        int res = 0;
        List amcl = [];
        List item = [];
        double sum = 0.0;
        res = controller.orderList
            .map((element) =>
                element == controller.eftpoSet.toList()[index] ? 1 : 0)
            .reduce((value, element) => value + element);

        amcl = controller
            .orderCal()[0][controller.eftpoSet.toList()[index].toString()]
            .toString()
            .split(",");
        sum = amcl.fold<double>(
            0, (prev, value) => prev + (double.tryParse(value ?? '0') ?? 0));

        item = controller
            .orderCal()[2][controller.eftpoSet.toList()[index].toString()]
            .toString()
            .split(",");

        return Card(
          color: Colors.blue.shade100,
          child: ExpansionTile(
            title: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "Eftpos",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(controller.eftpoSet.toList()[index].toString()),
              trailing: Text(sum.toPrecision(2).toString()),
            ),
            children: [
              ListView.builder(
                itemCount: item.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, itemIndex) {
                  try {
                    return ListTile(
                      title: Text(item[itemIndex].toString()),
                      trailing: Text(amcl[itemIndex].toString()),
                      dense: true,
                    );
                  } catch (e) {
                    return ListTile(
                      title: Text(item[itemIndex].toString()),
                      trailing: Text("".toString()),
                      dense: true,
                    );
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  ListTile shopSelect(BuildContext context) {
    return ListTile(
      onTap: () {
        shopNameDialog(controller, context);
      },
      title: const Text("Shop"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            controller.shopName.toString(),
            style: const TextStyle(color: Colors.black),
          ),
          const Icon(Icons.arrow_drop_down)
        ],
      ),
    );
  }

  ListView analysisItem() {
    return ListView.builder(
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
              .map((element) =>
                  element == controller.categorySet.toList()[index] ? 1 : 0)
              .reduce((value, element) => value + element);

          amcl = controller
              .cal()[controller.categorySet.toList()[index].toString()]
              .toString()
              .split(",");
          sum = amcl.fold<double>(
              0, (prev, value) => prev + (double.tryParse(value ?? '0') ?? 0));
        } else {
          res = controller.itemList
              .map((element) =>
                  element == controller.itemSet.toList()[index] ? 1 : 0)
              .reduce((value, element) => value + element);

          amcl = controller
              .itemCal()[controller.itemSet.toList()[index].toString()]
              .toString()
              .split(",");
          sum = amcl.fold<double>(
              0, (prev, value) => prev + (double.tryParse(value ?? '0') ?? 0));
        }
        return Card(
            color: Colors.blue.shade100,
            child: ExpansionTile(
              title: Text(
                controller.sortValue == 0
                    ? controller.categorySet.toList()[index].toString()
                    : controller.itemSet.toList()[index].toString(),
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.w500),
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
    );
  }

  Future<dynamic> paymentDialog(
      ReportingController controller, BuildContext context) {
    Circle processIndicator = Circle();

    return showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Payment Mode"),
        content: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    controller.paymentMode = 0;
                    setState(() {});
                    Get.back();
                  },
                  dense: true,
                  title: const Text("All"),
                  trailing: controller.paymentMode == 0
                      ? const Icon(Icons.check)
                      : null,
                ),
                ListTile(
                  onTap: () {
                    controller.paymentMode = 1;
                    setState(() {});
                    Get.back();
                  },
                  dense: true,
                  title: const Text("Cash"),
                  trailing: controller.paymentMode == 1
                      ? const Icon(Icons.check)
                      : null,
                ),
                ListTile(
                  onTap: () {
                    controller.paymentMode = 2;
                    setState(() {});
                    Get.back();
                  },
                  dense: true,
                  title: const Text("Eftpos"),
                  trailing: controller.paymentMode == 2
                      ? const Icon(Icons.check)
                      : null,
                ),
              ],
            )),
      ),
    );
  }

  Future<dynamic> shopNameDialog(
      ReportingController controller, BuildContext context) {
    Circle processIndicator = Circle();

    return showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Shop Name"),
        content: Material(
          color: Colors.transparent,
          child: SizedBox(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.shopNameSet.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    processIndicator.show(context);
                    controller.shopName =
                        controller.shopNameSet.toList()[index];
                    controller
                        .reportingAPI(context)
                        .then((value) => setState(() {
                              // processIndicator.hide(context);
                            }));
                    Get.back();
                  },
                  title: Text(controller.shopNameSet.toList()[index]),
                  dense: true,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> chartDialog(
      ReportingController controller, BuildContext context) {
    return showDialog(
        builder: (context) => CupertinoAlertDialog(
              title: const Text("Filter "),
              content: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    ListTile(
                      tileColor: Colors.transparent,
                      title: const Text("By Payment"),
                      dense: true,
                      onTap: () {
                        controller.sortValue = 2;
                        controller.update();
                        Get.back();
                        setState(() {});
                      },
                    ),
                    const Divider(height: 2),
                    ListTile(
                      tileColor: Colors.transparent,
                      title: const Text("By Category"),
                      dense: true,
                      onTap: () {
                        controller.sortValue = 0;
                        controller.update();
                        Get.back();
                        setState(() {});
                      },
                    ),
                    const Divider(height: 2),
                    ListTile(
                      tileColor: Colors.transparent,
                      title: const Text("By Product"),
                      dense: true,
                      onTap: () {
                        controller.sortValue = 1;
                        controller.update();
                        Get.back();
                        setState(() {});
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
  }
}
