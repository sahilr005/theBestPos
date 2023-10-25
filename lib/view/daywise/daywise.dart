import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/model/dayitemsModel.dart';
import 'package:order/utils/nodata.dart';
import 'package:order/utils/repository/network_repository.dart';

class DayWiseReportScreen extends StatefulWidget {
  const DayWiseReportScreen({super.key});

  @override
  State<DayWiseReportScreen> createState() => DdaywiseSWiseReportScreen();
}

class DdaywiseSWiseReportScreen extends State<DayWiseReportScreen> {
  @override
  void initState() {
    apiCall();
    super.initState();
  }

  DayitemsModel? dayitemsModel;
  apiCall() async {
    dayitemsModel = await networkRepository.datWiseItem(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Day Wise Item"), centerTitle: true),
      body: dayitemsModel == null ||
              dayitemsModel!.dayitems == null ||
              dayitemsModel!.dayitems!.length.isLowerThan(1)
          ? Center(
              child: NoData(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: dayitemsModel!.dayitems!.length,
                itemBuilder: (context, index) {
                  Dayitems item = dayitemsModel!.dayitems![index];
                  return Card(
                    child: ListTile(
                      title: Text(item.itemname.toString()),
                      // trailing: CupertinoSwitch(
                      //   value: isOn,
                      //   onChanged: (newValue) {
                      //     onOffItem(
                      //         eatin: newValue ? "Y" : "N",
                      //         itemid: item.itemid.toString());
                      //   },
                      // ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
