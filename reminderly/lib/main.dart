import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Views/LoginScreen.dart';

// import 'package:reminderly/Views/VerificationPage.dart';

Future main() async {
  await DotEnv().load(fileName: '.env');
  runApp(Reminderz());
}

class Reminderz extends StatefulWidget {
  @override
  _ReminderzState createState() => _ReminderzState();
}

class _ReminderzState extends State<Reminderz> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: kThemeData,
      home: SafeArea(child: LoginScreen()),
      debugShowCheckedModeBanner: false,
    );
  }
}
