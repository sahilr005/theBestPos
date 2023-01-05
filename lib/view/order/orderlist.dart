// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:order/config/common.dart';
import 'package:order/controller/orderlist_controller.dart';
import 'package:order/utils/nodata.dart';
import 'package:order/view/order/order_details.dart';

class OrderListScreen extends StatelessWidget {
  OrderListScreen({super.key});
  final OrderListController orderListController = OrderListController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order List"),
        centerTitle: true,
      ),
      body: GetBuilder<OrderListController>(
          init: OrderListController(),
          initState: (_) {
            orderListController.orderList(context);
          },
          builder: (controller) {
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
                          controller.orderList(context);
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
                          controller.orderList(context);
                          controller.update();
                        },
                      ),
                    ),
                    height(10),
                    if (controller.orderData.isEmpty) NoData(),
                    Card(
                        child: ListView.builder(
                      itemCount: controller.orderData.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Get.to(() => OrderDetailsScreen(
                                      orderId: controller.orderData[index]
                                          ["WebOrder"],
                                      context: context,
                                    ));
                              },
                              title:
                                  Text(controller.orderData[index]["CustName"]),
                              subtitle: Text(
                                  "Order ${controller.orderData[index]["WebOrder"]}"),
                              trailing: Text(
                                  controller.orderData[index]["OrderDueDate"]),
                            ),
                            const Divider(
                              height: 3,
                            )
                          ],
                        );
                      },
                    ))
                  ],
                ),
              ),
            );
          }),
    );
  }
}
