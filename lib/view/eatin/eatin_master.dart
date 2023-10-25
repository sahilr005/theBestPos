import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/model/EatInItemModel.dart';
import 'package:order/utils/nodata.dart';
import 'package:order/utils/repository/network_repository.dart';

class EatinScreen extends StatefulWidget {
  const EatinScreen({super.key});

  @override
  State<EatinScreen> createState() => _EatinScreenState();
}

class _EatinScreenState extends State<EatinScreen> {
  @override
  void initState() {
    apiCall();
    super.initState();
  }

  EatInItemModel? eatInItemModel;
  apiCall() async {
    eatInItemModel = await networkRepository.eatInItems(context: context);
    setState(() {});
  }

  onOffItem({required String eatin, required String itemid}) async {
    eatInItemModel = await networkRepository.onOffItems(
        context: context, eatin: eatin, itemid: itemid);
    apiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EatIn"),
        centerTitle: true,
        // backgroundColor: ,
      ),
      body: eatInItemModel == null ||
              eatInItemModel!.eatitems == null ||
              eatInItemModel!.eatitems!.length.isLowerThan(1)
          ? Center(
              child: NoData(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: eatInItemModel!.eatitems!.length,
                itemBuilder: (context, index) {
                  Eatitems item = eatInItemModel!.eatitems![index];
                  bool isOn = item.usedInEatin == "Y";

                  return Card(
                    child: ListTile(
                      title: Text(item.itemname.toString()),
                      trailing: CupertinoSwitch(
                        value: isOn,
                        onChanged: (newValue) {
                          onOffItem(
                              eatin: newValue ? "Y" : "N",
                              itemid: item.itemid.toString());
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
