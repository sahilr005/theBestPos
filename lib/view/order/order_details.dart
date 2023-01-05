import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:order/config/common.dart';
import 'package:order/controller/orderlist_controller.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Detail"),
        centerTitle: true,
      ),
      body: GetBuilder<OrderListController>(builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            const ListTile(
              title: Text("Name"),
              trailing: Text("Tester"),
            ),
            ListTile(
              title: const Text("Order Date"),
              trailing: Text(DateFormat.yMEd().format(controller.toDate)),
            ),
            ListTile(
              title: const Text("Delivery/Pickup Date"),
              trailing: Text(DateFormat.yMEd().format(controller.toDate)),
            ),
            ListTile(
              title: const Text("Delivery/Pickup Time"),
              trailing: Text(DateFormat.jm().format(controller.toDate)),
            ),
            height(10),
            ListView.builder(
                itemCount: 2,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return Card(
                    child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Table(
                          children: [
                            TableRow(children: [
                              Text('$index)Main Course- NON VEG'),
                              const Text('NB'),
                              const Text('\$19.30'),
                            ]),
                            const TableRow(children: [
                              Divider(),
                              Divider(),
                              Divider(),
                            ]),
                            const TableRow(children: [
                              Text('LARGE'),
                              Text('+ 1'),
                              Text('\$0'),
                            ])
                          ],
                        )),
                  );
                }),
          ]),
        );
      }),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Total :- \$43.20",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
