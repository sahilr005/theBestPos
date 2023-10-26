import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
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
      appBar: AppBar(title: Text("Daywise Item"), centerTitle: true),
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
                        trailing: InkWell(
                            onTap: () async{
                             await showDialog(
                                context: context,
                                builder: (context) {
                                  return DaySelectionDialog(
                                      itemId: item.itemid.toString(),
                                      daystr: item.daystr!);
                                },
                              ).whenComplete(() async{
                                 apiCall();
                              });
                            },
                            child: Icon(Icons.calendar_month))),
                  );
                },
              ),
            ),
    );
  }
}

class DaySelectionDialog extends StatefulWidget {
  final String daystr;
  final String itemId;

  DaySelectionDialog({required this.daystr, required this.itemId});

  @override
  _DaySelectionDialogState createState() => _DaySelectionDialogState();
}

class _DaySelectionDialogState extends State<DaySelectionDialog> {
  Map<String, bool> daySelection = {};
  final Map<String, String> fullDayNames = {
    'SUN': 'Sunday',
    'MON': 'Monday',
    'TUE': 'Tuesday',
    'WED': 'Wednesday',
    'THU': 'Thursday',
    'FRI': 'Friday',
    'SAT': 'Saturday',
  };

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic> daystrData = json.decode(widget.daystr);
    daystrData.forEach((key, value) {
      daySelection[key] = value == "1";
    });
  }

  void updateDaystr() async {
    final updatedDaystrData = {
      'SUN': daySelection['SUN'] == true ? "1" : "0",
      'MON': daySelection['MON'] == true ? "1" : "0",
      'TUE': daySelection['TUE'] == true ? "1" : "0",
      'WED': daySelection['WED'] == true ? "1" : "0",
      'THU': daySelection['THU'] == true ? "1" : "0",
      'FRI': daySelection['FRI'] == true ? "1" : "0",
      'SAT': daySelection['SAT'] == true ? "1" : "0",
    };

    final updatedDaystr = json.encode(updatedDaystrData);
    await networkRepository.datWiseItemUpdate(
      context: context,
      daystr: updatedDaystr,
      itemid: widget.itemId,
    );
    
    print(updatedDaystr);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Select Days'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var day in ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'])
          ListTile(
            title:  Text(fullDayNames[day]!),
            trailing: Checkbox(
                  value: daySelection[day] ?? false,
                  onChanged: (bool? newValue) {
                    setState(() {
                      daySelection[day] = newValue!;
                      updateDaystr();
                      Get.back();
                    });
                  },
                ),
          )
            
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Handle the selection and update the daystr here
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

