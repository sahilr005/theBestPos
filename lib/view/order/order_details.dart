import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order/config/common.dart';
import 'package:order/utils/common_method.dart';
import 'package:order/utils/repository/network_repository.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  final BuildContext context;
  const OrderDetailsScreen(
      {super.key, required this.orderId, required this.context});
  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  // final OrderListController controller = OrderListController();
  List orderDetailsData = [];

  orderDetails(context) async {
    var res = await networkRepository.orderDetails(context, widget.orderId);
    if (res["status"] == "failure") {
      CommonMethod().getXSnackBar('Error', res["status"], Colors.red);
    }
    if (res["orders"] != null) {
      orderDetailsData = res["orders"];
      setState(() {});
    }
  }

  @override
  void initState() {
    setState(() {
      Future.delayed(Duration.zero, () {
        orderDetails(widget.context);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Detail"),
        centerTitle: true,
      ),
      body: orderDetailsData.isEmpty
          ? const Center()
          : Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                    children: orderDetailsData.isEmpty
                        ? []
                        : [
                            ListTile(
                              title: const Text("Name"),
                              trailing: Text(orderDetailsData[0]["CustName"]),
                              dense: true,
                            ),
                            ListTile(
                              title: const Text("Contact"),
                              trailing: Text(orderDetailsData[0]["CustPhone"]),
                              dense: true,
                            ),
                            ListTile(
                              dense: true,
                              title: const Text("Order Date"),
                              trailing:
                                  Text(orderDetailsData[0]["WebOrderDate"]),
                            ),
                            ListTile(
                              dense: true,
                              title: const Text("Delivery/Pickup Date"),
                              trailing: Text(orderDetailsData[0]["WebDueDate"]),
                            ),
                            ListTile(
                              dense: true,
                              title: const Text("Delivery/Pickup Time"),
                              trailing: Text(DateFormat.jm().format(
                                  DateFormat("hh:mm:ss").parse(
                                      orderDetailsData[0]["WebDueTime"]))),
                            ),
                            height(10),
                            ListView.builder(
                                itemCount: orderDetailsData[0]["items"].length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (_, index) {
                                  return Card(
                                    child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Table(
                                          children: [
                                            TableRow(children: [
                                              Text(orderDetailsData[0]["items"]
                                                  [index]["WebItem"]),
                                              Text(orderDetailsData[0]["items"]
                                                  [index]["WebItemBase"]),
                                              Text(orderDetailsData[0]["items"]
                                                  [index]["WebItemPrice"]),
                                            ]),
                                            TableRow(
                                                children: orderDetailsData[0]
                                                                ["items"][index]
                                                            ["WebToppingItems"]
                                                        .isEmpty
                                                    ? [
                                                        const SizedBox(),
                                                        const SizedBox(),
                                                        const SizedBox(),
                                                      ]
                                                    : [
                                                        const Divider(),
                                                        const Divider(),
                                                        const Divider(),
                                                      ]),
                                            if (orderDetailsData[0]["items"]
                                                            [index]
                                                        ["WebToppingItems"] !=
                                                    null &&
                                                orderDetailsData[0]["items"]
                                                            [index]
                                                        ["WebToppingItems"]
                                                    .isNotEmpty)
                                              TableRow(children: [
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: orderDetailsData[0]
                                                              ["items"][index]
                                                          ["WebToppingItems"]
                                                      .length,
                                                  itemBuilder: (context, ind) {
                                                    return Text(orderDetailsData[
                                                                            0][
                                                                        "items"]
                                                                    [
                                                                    index]
                                                                [
                                                                "WebToppingItems"]
                                                            [ind]["WebTopping"]
                                                        .toString());
                                                  },
                                                ),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: orderDetailsData[0]
                                                              ["items"][index]
                                                          ["WebToppingItems"]
                                                      .length,
                                                  itemBuilder: (context, ind) {
                                                    return Text(
                                                        "${orderDetailsData[0]["items"][index]["WebToppingItems"][ind]["WebAddRemove"]}1");
                                                  },
                                                ),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: orderDetailsData[0]
                                                              ["items"][index]
                                                          ["WebToppingItems"]
                                                      .length,
                                                  itemBuilder: (context, ind) {
                                                    return Text(orderDetailsData[
                                                                            0][
                                                                        "items"]
                                                                    [
                                                                    index]
                                                                [
                                                                "WebToppingItems"]
                                                            [
                                                            ind]["WebToppingPrice"]
                                                        .toString());
                                                  },
                                                ),
                                              ]),
                                          ],
                                        )),
                                  );
                                }),
                          ]),
              ),
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.only(bottom: 25,left: 20,right: 20),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: orderDetailsData.isEmpty
              ? []
              : [
                  Text(
                    "Total :- \$${orderDetailsData[0]['WebTotalAmt']}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
        ),
      ),
    );
  }
}
