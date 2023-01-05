import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/config/common.dart';

class InternetError {
  static final _instance = InternetError.internal();
  factory InternetError() => _instance;
  InternetError.internal();

  static OverlayEntry? entry;

  void show(context, page) => addOverlayEntry(context);
  void hide() => removeOverlay();

  bool get isShow => entry != null;

  addOverlayEntry(context) {
    if (entry != null) return;
    entry = OverlayEntry(builder: (BuildContext context) {
      return LayoutBuilder(builder: (_, BoxConstraints constraints) {
        return Material(
          color: Colors.black,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "No internet connection",
                  ),
                  height(10),
                  const Text(
                    "Please check your keyword or try again your browsing keyword",
                    textAlign: TextAlign.center,
                  ),
                  height(30),
                  TextButton(
                      child: const Text("Try again"),
                      onPressed: () {
                        removeOverlay();
                      }),
                  height(15),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 60,
                      width: Get.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: const Center(
                        child: Text(
                          "Check your network",
                        ),
                      ),
                    ),
                  ),

                  //   Center(
                  // child: Column(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Image.asset(
                  //       'assets/gif/no-internet.gif',
                  //       height: 250,
                  //     ),
                  //     const SizedBox(
                  //       height: 50,
                  //     ),
                  //     const Text(
                  //       "Please check your internet connection!",
                  //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  //     ),
                  //     const SizedBox(
                  //       height: 20,
                  //     ),
                  //     SizedBox(
                  //       // decoration: BoxDecoration(
                  //       //   borderRadius: BorderRadius.circular(50),
                  //       // ),
                  //       height: 50,
                  //       width: 200,
                  //       child: TextButton(
                  //         style: TextButton.styleFrom(
                  //           backgroundColor: Colors.black.withOpacity(0.1),
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(50.0),
                  //           ),
                  //         ),
                  //         onPressed: () {
                  //           removeOverlay();
                  //         },
                  //         child: const Text(
                  //           "Okay",
                  //           style:
                  //               TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  //         ),
                  //       ),
                  //     ),
                ],
              ),
            ),
          ),
        );
      });
    });

    addoverlay(entry!, context);
  }

  addoverlay(OverlayEntry entry, context) async {
    Overlay.of(context)!.insert(entry);
  }

  removeOverlay() {
    entry?.remove();
    entry = null;
  }
}
