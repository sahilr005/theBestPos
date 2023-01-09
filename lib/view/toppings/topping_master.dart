import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order/utils/common_method.dart';
import 'package:order/utils/repository/network_repository.dart';

class ToppingMasterScreen extends StatefulWidget {
  const ToppingMasterScreen({super.key});

  @override
  State<ToppingMasterScreen> createState() => _ToppingMasterScreenState();
}

class _ToppingMasterScreenState extends State<ToppingMasterScreen> {
  List toppingData = [];
  topping(context) async {
    var res = await networkRepository.toppingApi(context);
    if (res["toppings"] != null) {
      toppingData = res["toppings"];
      setState(() {});
    } else {
      CommonMethod().getXSnackBar('Error', res["status"], Colors.red);
    }
  }

  toppingUpdate(context, {required name, required status}) async {
    await networkRepository.toppingApi(context, name: name, off: status);
    topping(context);
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () => topping(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Topping Master"),
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
                    toppingData.length,
                    (index) => DataRow(cells: [
                      DataCell(Text(index.toString())),
                      DataCell(Text(toppingData[index]["Name"].toString())),
                      DataCell(CupertinoSwitch(
                          value: toppingData[index]["active"] == "Y",
                          onChanged: (value) {
                            toppingUpdate(context,
                                name: toppingData[index]["Name"],
                                status: value ? "Y" : "N");
                          })),
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
}
