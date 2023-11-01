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
      controller.shopNameGet(context).then((value) {
        {
          // controller.reportingAPI(context).then((value) => setState(() {}));
          setState(() {});
        }
      });
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
                            lastDate: DateTime.now(),
                          ))!;
                          // ignore: use_build_context_synchronously
                          //  await controller.shopNameGetOnly(context);
                          await controller
                              .reportingAPI(context)
                              .then((value) => setState(() {}));
                          controller.update();
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text(
                          "To : ${DateFormat.yMMMMEEEEd().format(controller.toDate)}",
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          controller.toDate = (await showDatePicker(
                            context: context,
                            initialDate: controller.toDate,
                            firstDate: controller.fromDate,
                            lastDate: DateTime.now(),
                          ))!;
                          // ignore: use_build_context_synchronously
                          // await controller.shopNameGetOnly(context);
                          await controller
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
                                // if (controller.sortValue == 2)
                                //   InkWell(
                                //     onTap: () {
                                //       paymentDialog(controller, context);
                                //     },
                                //     child: Row(
                                //       children: [
                                //         Text(controller.paymentMode == 0
                                //             ? "All"
                                //             : controller.paymentMode == 1
                                //                 ? "Cash"
                                //                 : "eftpos"),
                                //         const Icon(Icons.arrow_drop_down)
                                //       ],
                                //     ),
                                //   ),
                                IconButton(
                                    onPressed: () {
                                      chartDialog(controller, context);
                                    },
                                    icon: const Icon(Icons.sort)),
                              ],
                            ),
                          )),
                    // if (controller.sortValue == 2 &&
                    //     controller.paymentMode == 2)
                    //   eftposDataList(),
                    // if (controller.sortValue == 2 &&
                    //     controller.paymentMode == 1)
                    //   cashDataList(),
                    if (controller.sortValue == 2 &&
                        controller.paymentMode == 0)
                      Obx(() =>
                          allPaymentList(controller.reportingDataModel.value)),

                    height(10),
                    if (controller.reportingData.isEmpty) NoData(),
                    if (controller.sortValue != 2) analysisItem(),
                    if (controller.reportingData.isNotEmpty &&
                        controller.sortValue != 2)
                      chartShow(),
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
                        Column(children: [
                          Text(controller.cashCount.length.toString())
                        ]),
                        Column(children: [
                          Text(
                              "${controller.orderSet.length - controller.cashCount.length}")
                        ]),
                        Column(children: [
                          Text(controller.orderSet.length.toString())
                        ]),
                      ]),
                      TableRow(children: [
                        Column(
                          children: [
                            Text(controller.cashPayment
                                .toPrecision(2)
                                .toString())
                          ],
                        ),
                        Column(
                          children: [
                            Text((controller.eftPayment)
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
                  subtitle: Text("Qty : "),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        controller.totalAmount.toPrecision(2).toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        controller.orderSet.length.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  )),
            if (controller.reportingData.isNotEmpty &&
                controller.sortValue != 2)
              ListTile(
                dense: true,
                title: Text(controller.sortValue == 0
                    ? "Category : "
                    : controller.sortValue != 2
                        ? "Product : "
                        : "Total Order"),
                trailing: Text(
                  controller.sortValue == 0
                      ? controller.categorySet.length.toString()
                      : controller.sortValue == 1
                          ? controller.itemSet.length.toString()
                          : controller.orderSet.length.toString(),
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
                  .calMap[controller.categorySet.toList()[ind].toString()]
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
                  .itemMapCal[controller.itemSet.toList()[ind].toString()]
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

  Widget allPaymentList(List<Order> orders) {
    // Group orders by otime
    Map<String, List<Order>> groupedOrdersByTime = {};
    orders.forEach((order) {
      if (!groupedOrdersByTime.containsKey(order.otime)) {
        groupedOrdersByTime[order.otime] = [];
      }
      groupedOrdersByTime[order.otime]!.add(order);
    });
    Set<String> uniqueOrdnoSet = {};
    num co = 0;
    num webAmount = 0;
    return ListView.builder(
      itemCount: orders.length + 1,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == orders.length) {
          return Card(
            color: Colors.green.shade50,
            child: ListTile(
              title: Text("Total Uber Eats(Eftpos)"),
              subtitle: Text("Total Amount "),
              trailing: Text(
                "$co"
                        "\n\$" +
                    webAmount.toStringAsFixed(2),
              ),
            ),
          );
        }
        Order order = orders[index];
        String paymentMethod;

        // Check the payment method based on the createby field
        if (order.createby == "Web") {
          // If payment is from Web and the method is Eftpos, show 'ubereat(eftpos)'
          paymentMethod =
              order.eftpos > 0.00 ? 'Uber Eats(Eftpos)' : 'Uber Eats(cash)';
        } else {
          // For other payments, use the existing logic
          paymentMethod = order.cash > 0.00 ? 'Cash' : 'Eftpos';
        }

        // Check if ordno has already been added
        if (uniqueOrdnoSet.contains(order.ordno)) {
          return SizedBox.shrink();
        } else {
          uniqueOrdnoSet.add(order.ordno);
        }
        if (paymentMethod == 'Uber Eats(Eftpos)') {
          co++;
          webAmount = webAmount + order.totamt;
        }

        return Card(
          color: Colors.blue.shade100,
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(paymentMethod),
                Text('\$${order.totamt}'),
              ],
            ),
            subtitle: Text('${order.otime}'),
            children: groupedOrdersByTime[order.otime]!.map((order) {
              return ListTile(
                title: Text('${order.itemnm}'),
                trailing: Text('\$${order.itmprice.toStringAsFixed(2)}'),
              );
            }).toList(),
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
    // controller.categorySet.toList().sort((a, b) => a[""],)
    Map data = {};
    List sumList = [];
    List recList = [];
    int res = 0;
    if (controller.sortValue == 0)
      for (var i = 0; i < controller.categorySet.length; i++) {
        int res = 0;
        List amcl = [];
        double sum = 0.0;
        res = controller.categoryList
            .map((element) =>
                element == controller.categorySet.toList()[i] ? 1 : 0)
            .reduce((value, element) => value + element);

        amcl = controller.calMap[controller.categorySet.toList()[i].toString()]
            .toString()
            .split(",");
        sum = amcl.fold<double>(
            0, (prev, value) => prev + (double.tryParse(value ?? '0') ?? 0));
        sumList.add(sum);
        sumList.sort();
        sumList = sumList.reversed.toList();

        data = {
          "1": res,
          "2": amcl,
          "3": sum,
        };
      }
    for (var i = 0; i < sumList.length; i++) {
      res = controller.itemList
          .map((element) => element == controller.itemSet.toList()[i] ? 1 : 0)
          .reduce((value, element) => value + element);
      recList.add(res);
    }

    List sumList2 = [];
    List recList2 = [];
    int res2 = 0;
    for (var i = 0; i < controller.itemSet.length; i++) {
      List amcl = [];
      double sum = 0.0;
      amcl = controller.itemMapCal[controller.itemSet.toList()[i].toString()]
          .toString()
          .split(",");
      sum = amcl.fold<double>(
          0, (prev, value) => prev + (double.tryParse(value ?? '0') ?? 0));
      sumList2.add(sum);
      sumList2.sort();
      sumList2 = sumList2.reversed.toList();

      data = {
        "1": res,
        "2": amcl,
        "3": sum,
      };
    }
    for (var i = 0; i < sumList2.length; i++) {
      res2 = controller.itemList
          .map((element) => element == controller.itemSet.toList()[i] ? 1 : 0)
          .reduce((value, element) => value + element);
      recList2.add(res2);
    }
    return ListView.builder(
      itemCount: controller.sortValue == 0 ? sumList.length : sumList2.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        double summ = 0.0;
        double persent = 0.0;
        double salesP = (sumList2[index] / controller.totalAmount) * 100;
        if (controller.sortValue == 0) {
          summ = sumList[index];
          persent = (recList[index] / controller.categoryList.length) * 100;
        } else {
          summ = sumList2[index];
          persent = (recList2[index] / controller.itemList.length) * 100;
        }
        return Card(
            color: Colors.blue.shade100,
            child: ExpansionTile(
              title: ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                trailing: Text("\$${summ.toPrecision(2)}"),
                title: Text(
                  controller.sortValue == 0
                      ? controller.categorySet.toList()[index].toString()
                      : controller.itemSet.toList()[index].toString(),
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              ),
              children: <Widget>[
                ListTile(
                  title: const Text("Qty. Sold"),
                  trailing: Text(recList2[index].toString()),
                  dense: true,
                ),
                ListTile(
                  title: const Text("% of Qty."),
                  trailing: Text("${persent.toPrecision(2)}%"), //
                  dense: true,
                ),
                ListTile(
                  title: const Text("	% of Sales"),
                  trailing: Text("${salesP.toPrecision(2)}%"),
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
      ReportingController controller, BuildContext context) async {
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
                  onTap: () async {
                    processIndicator.show(context);
                    controller.shopName =
                        controller.shopNameSet.toList()[index];
                    // await controller.shopNameGetOnly(context);
                    await controller
                        .reportingAPI(context)
                        .then((value) => setState(() {
                              // processIndicator.hide(context);
                            }));
                    Get.back();
                  },
                  trailing: controller.shopName ==
                          controller.shopNameSet.toList()[index]
                      ? const Icon(Icons.check)
                      : null,
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

class Order {
  final String posid;
  final String odate;
  final String otime;
  final String ordno;
  final String createby;
  final double totamt;
  final double ordgst;
  final double salesex;
  final double discamt;
  final double paidamt;
  final String compnm;
  final String puser;
  final String shopnm;
  final double cash;
  final double eftpos;
  final int onaccount;
  final String category;
  final String itemid;
  final String itemnm;
  final String base;
  final String size;
  final int qty;
  final double itmprice;
  final double costprice;
  final int lineno;
  final String categ;
  final int status;
  final String daid;

  Order({
    required this.posid,
    required this.odate,
    required this.otime,
    required this.ordno,
    required this.createby,
    required this.totamt,
    required this.ordgst,
    required this.salesex,
    required this.discamt,
    required this.paidamt,
    required this.compnm,
    required this.puser,
    required this.shopnm,
    required this.cash,
    required this.eftpos,
    required this.onaccount,
    required this.category,
    required this.itemid,
    required this.itemnm,
    required this.base,
    required this.size,
    required this.qty,
    required this.itmprice,
    required this.costprice,
    required this.lineno,
    required this.categ,
    required this.status,
    required this.daid,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      posid: json['posid'],
      odate: json['odate'],
      otime: json['otime'],
      ordno: json['ordno'],
      createby: json['createby'],
      totamt: double.parse(json['totamt']),
      ordgst: double.parse(json['ordgst']),
      salesex: double.parse(json['salesex']),
      discamt: double.parse(json['discamt']),
      paidamt: double.parse(json['paidamt']),
      compnm: json['compnm'],
      puser: json['puser'],
      shopnm: json['shopnm'],
      cash: double.parse(json['cash']),
      eftpos: double.parse(json['eftpos']),
      onaccount: int.parse(json['onaccount']),
      category: json['category'],
      itemid: json['itemid'],
      itemnm: json['itemnm'],
      base: json['base'],
      size: json['size'],
      qty: int.parse(json['qty']),
      itmprice: double.parse(json['itmprice']),
      costprice: double.parse(json['costprice']),
      lineno: int.parse(json['lineno']),
      categ: json['categ'],
      status: int.parse(json['status']),
      daid: json['daid'],
    );
  }
}
