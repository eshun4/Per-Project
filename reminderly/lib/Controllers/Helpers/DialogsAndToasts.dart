import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Models/Widgets/CustomProgressIndicator.dart';

class DialogsAndToasts {
  //Show Error dialog
  static void showErroDialog(
      {String title = 'Error', String description = 'Something went wrong'}) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Get.textTheme.headline4,
              ),
              Text(
                description ?? '',
                style: Get.textTheme.headline6,
              ),
              ElevatedButton(
                onPressed: () {
                  if (Get.isDialogOpen) Get.back();
                },
                child: Text('Okay'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Show Snackbar
  static void showSnackBar({String title, String message, Icon icon}) {
    Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      duration: Duration(seconds: 10),
      backgroundGradient: LinearGradient(colors: [
        kMaroon,
        kBLue,
        kIndigo,
        kMaroon,
        kBLue,
        kMaroon,
      ], begin: Alignment.bottomRight, end: Alignment.bottomLeft),
      icon: icon,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(20),
    );
  }

  //show loading
  static void showLoading([String message]) {
    Get.dialog(CustomProgressIndicator());
  }

  //hide loading
  static void hideLoading() {
    if (Get.isDialogOpen) Get.back();
  }
}
