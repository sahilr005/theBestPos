import 'package:flutter/material.dart';

class ReportDetails extends StatefulWidget {
  final data;
  const ReportDetails({super.key, this.data});

  @override
  State<ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Details"),
      ),
    );
  }
}
