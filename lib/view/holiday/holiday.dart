import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:order/model/HolidayStausModel.dart';
import 'package:order/model/holiday_model.dart';
import 'package:order/utils/repository/network_repository.dart';

class HolidayMaster extends StatefulWidget {
  const HolidayMaster({super.key});

  @override
  State<HolidayMaster> createState() => _HolidayMasterState();
}

class _HolidayMasterState extends State<HolidayMaster> {
  bool isSwitched = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool isHoliday = false;

  Rx<HolidayModel> holidayModel = HolidayModel().obs;
  Rx<HolidayStatusModel> holidayStatusModel = HolidayStatusModel().obs;
  getHoliday() async {
    holidayModel.value = await networkRepository.holidayCall(context);
  }

  getTitle() async {
    holidayStatusModel.value =
        await networkRepository.holidayStatusCall(context);
    titleController.text = holidayStatusModel.value.title.toString();
    descController.text = holidayStatusModel.value.description.toString();
    isHoliday = holidayStatusModel.value.status.toString() == "1";
    setState(() {});
    getHoliday();
  }

  updateData() async {
    await networkRepository.updateHolidayStatus(
      context: context,
      title: titleController.text,
      description: descController.text,
      status: isHoliday ? 1 : 0,
    );
    setState(() {});
    getTitle();
  }

  addHoliday({fromDate, toDate}) async {
    await networkRepository.addHoliday(
        context: context, fromDate: fromDate, toDate: toDate);
    await getHoliday();
    Navigator.of(context).pop();
  }

  editHoliday({fromDate, toDate, id}) async {
    await networkRepository.editHoliday(
        context: context, fromDate: fromDate, id: id, toDate: toDate);
  }

  deleteHoliday({id}) async {
    await networkRepository.deleteHoliday(context: context, id: id);
    await getHoliday();
    Navigator.of(context).pop();
  }

  Future<void> _showEditDialog(
      String id, String defaultFromDate, String defaultToDate) async {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    Rx<DateTime> newFromDate = dateFormat.parse(defaultFromDate).obs;
    Rx<DateTime> newToDate = dateFormat.parse(defaultToDate).obs;
    Rx<TextEditingController> fromDate =
        TextEditingController(text: defaultFromDate).obs;
    Rx<TextEditingController> toDate =
        TextEditingController(text: defaultToDate).obs;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Holiday"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Obx(() => TextFormField(
                    decoration: InputDecoration(labelText: "New From Date"),
                    controller: fromDate.value,
                    readOnly: true,
                    onTap: () async {
                      final pickedFromDate = await showDatePicker(
                        context: context,
                        initialDate: newFromDate.value,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedFromDate != null) {
                        newFromDate.value = pickedFromDate;
                        fromDate.value.text =
                            DateFormat('dd-MM-yyyy').format(newFromDate.value);
                      }
                    },
                  )),
              TextFormField(
                readOnly: true,
                controller: toDate.value,
                decoration: InputDecoration(labelText: "New To Date"),
                onTap: () async {
                  final pickedTODate = await showDatePicker(
                    context: context,
                    initialDate: newToDate.value,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedTODate != null) {
                    newToDate.value = pickedTODate;
                    toDate.value.text =
                        DateFormat('dd-MM-yyyy').format(newToDate.value);
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () async {
                await editHoliday(
                    fromDate: fromDate.value.text,
                    toDate: toDate.value.text,
                    id: id);
                getHoliday();
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showDeleteConfirmationDialog(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this Holiday?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                await deleteHoliday(id: id);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showAddDialog() async {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    Rx<DateTime> newFromDate = DateTime.now().obs;
    Rx<DateTime> newToDate = DateTime.now().obs;
    Rx<TextEditingController> fromDate = TextEditingController().obs;
    Rx<TextEditingController> toDate = TextEditingController().obs;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Holiday"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Obx(() => TextFormField(
                    decoration: InputDecoration(labelText: "From Date"),
                    controller: fromDate.value,
                    readOnly: true,
                    onTap: () async {
                      final pickedFromDate = await showDatePicker(
                        context: context,
                        initialDate: newFromDate.value,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedFromDate != null) {
                        newFromDate.value = pickedFromDate;
                        fromDate.value.text =
                            DateFormat('dd-MM-yyyy').format(newFromDate.value);
                      }
                    },
                  )),
              Obx(() => TextFormField(
                    decoration: InputDecoration(labelText: "To Date"),
                    controller: toDate.value,
                    readOnly: true,
                    onTap: () async {
                      final pickedTODate = await showDatePicker(
                        context: context,
                        initialDate: newToDate.value,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedTODate != null) {
                        newToDate.value = pickedTODate;
                        toDate.value.text =
                            DateFormat('dd-MM-yyyy').format(newToDate.value);
                      }
                    },
                  )),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () async {
                final selectedFromDate = fromDate.value.text;
                final selectedToDate = toDate.value.text;
                await addHoliday(
                    fromDate: selectedFromDate, toDate: selectedToDate);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getTitle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Holiday Master"),
        actions: [
          Center(
            child: OutlinedButton.icon(
              icon: Icon(Icons.add),
              onPressed: () async {
                await showAddDialog();
              },
              label: Text("Add Holiday"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Holiday Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  // HtmlWidget(
                  //   """${descController.text}""",
                  // ),
                  TextField(
                    controller: descController,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: isHoliday,
                    onChanged: (v) {
                      isHoliday = v;
                      setState(() {});
                    },
                    title: Text("Is Holiday?"),
                  ),
                  OutlinedButton(
                      onPressed: () async {
                        await updateData();
                      },
                      child: Text("Update")),
                ],
              ),
            ),
            // Divider(),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(
                "Holiday Date",
                style: TextStyle(fontSize: 18),
              ),
              children: [
                Obx(() => holidayModel.value.holidays != null
                    ? ListView.builder(
                        itemCount: holidayModel.value.holidays!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(holidayModel
                                      .value.holidays![index].fdt
                                      .toString() +
                                  " - " +
                                  holidayModel.value.holidays![index].tdt
                                      .toString()),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                      onTap: () async {
                                        await _showEditDialog(
                                          holidayModel
                                              .value.holidays![index].id!,
                                          holidayModel
                                              .value.holidays![index].fdt!,
                                          holidayModel
                                              .value.holidays![index].tdt!,
                                        );
                                      },
                                      child:
                                          Icon(Icons.edit, color: Colors.blue)),
                                  InkWell(
                                      onTap: () async {
                                        await showDeleteConfirmationDialog(
                                          holidayModel
                                              .value.holidays![index].id!,
                                        );
                                      },
                                      child: Icon(Icons.delete,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : SizedBox()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
