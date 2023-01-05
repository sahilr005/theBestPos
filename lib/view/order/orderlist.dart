import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:order/config/common.dart';
import 'package:order/controller/orderlist_controller.dart';
import 'package:order/view/order/order_details.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order List"),
        centerTitle: true,
      ),
      body: GetBuilder<OrderListController>(
          init: OrderListController(),
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
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
                          firstDate: DateTime(2000),
                          lastDate: DateTime(3000),
                        ))!;
                        controller.update();
                      },
                    ),
                  ),
                  height(10),
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
                        controller.update();
                      },
                    ),
                  ),
                  height(10),
                  Card(
                      child: ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Get.to(() => const OrderDetailsScreen());
                            },
                            title: const Text("Phillip"),
                            subtitle: const Text("Order 3331"),
                            trailing: Text(
                                DateFormat.yMEd().format(controller.toDate)),
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
            );
          }),
    );
  }
}
