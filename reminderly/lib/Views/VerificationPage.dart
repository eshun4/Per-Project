import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Controllers/Services/User_services.dart';
import 'package:reminderly/Models/User.dart';
import 'package:reminderly/Models/Widgets/ButtonWidget.dart';

// ignore: must_be_immutable
class VerifyUser extends StatefulWidget {
  final User user;
  final String response;
  VerifyUser({this.user, this.response});

  @override
  _VerifyUserState createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  UserServices _servicesController = new UserServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kMaroon,
            kBLue,
            kMaroon,
            kIndigo,
            kMaroon,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: kIndigo, width: 4),
                    color: kMaroon,
                    borderRadius: BorderRadius.all(Radius.circular(35))),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 25),
                      Text(
                        "Hi ${widget.user.firstname},",
                        style: kLargeText,
                        textDirection: TextDirection.ltr,
                      ),
                      SizedBox(height: 25),
                      CircleAvatar(
                          radius: 70,
                          child: Icon(Icons.email_outlined,
                              size: 100, color: Colors.white)),
                      SizedBox(height: 25),
                      Text('Press the button below to verify your email.',
                          textDirection: TextDirection.ltr, style: kFlatButton),
                      SizedBox(height: 25),
                      CustomButton1(
                        yourConstraints:
                            BoxConstraints.expand(height: 60, width: 320),
                        whenPressed: () {
                          verify();
                        },
                        colorChoice: kBLue,
                        widgetChoice: Center(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Verify Email',
                                  style: kButton,
                                ),
                                SizedBox(width: 15),
                                Icon(
                                  Icons.verified_sharp,
                                  color: Colors.white,
                                  size: 45,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )
        ],
      ),
    ));
  }

  void verify() {
    _servicesController.verifyUser();
    showDialog();
  }

  static void showDialog(
      {String title = 'Message', String description = 'Verify Account'}) {
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
                  Get.back();
                  Get.back();
                },
                child: Text('Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
