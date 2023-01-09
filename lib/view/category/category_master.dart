import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order/utils/common_method.dart';
import 'package:order/utils/repository/network_repository.dart';

class CategoryMasterScreen extends StatefulWidget {
  const CategoryMasterScreen({super.key});

  @override
  State<CategoryMasterScreen> createState() => _CategoryMasterScreenState();
}

class _CategoryMasterScreenState extends State<CategoryMasterScreen> {
  List categoryData = [];
  category(context) async {
    var res = await networkRepository.categoryApi(context);
    if (res["categories"] != null) {
      categoryData = res["categories"];
      setState(() {});
    } else {
      CommonMethod().getXSnackBar('Error', res["status"], Colors.red);
    }
  }

  categoryUpdate(context, {required String catid, status}) async {
        await networkRepository.categoryApi(context, catid: catid, off: status);
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
        title: const Text("Category Master"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    categoryData.length,
                    (index) => DataRow(cells: [
                      DataCell(Text(index.toString())),
                      DataCell(Text(categoryData[index]["name"])),
                      DataCell(CupertinoSwitch(
                          value: categoryData[index]["active"] == "Y",
                          onChanged: (value) {
                            categoryUpdate(context,
                                catid: categoryData[index]["catid"],
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
