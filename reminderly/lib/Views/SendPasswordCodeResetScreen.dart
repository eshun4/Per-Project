import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Controllers/Services/User_services.dart';
import 'package:reminderly/Models/Widgets/ButtonWidget.dart';
import 'package:reminderly/Models/Widgets/TextFields.dart';
import 'package:reminderly/Views/ResetPasswordScreen.dart';

// ignore: must_be_immutable
class SendPasswordResetCodeScreen extends StatefulWidget {
  @override
  _SendPasswordResetCodeScreenState createState() =>
      _SendPasswordResetCodeScreenState();
}

class _SendPasswordResetCodeScreenState
    extends State<SendPasswordResetCodeScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  UserServices _controller = new UserServices();
  TextEditingController _emailController = TextEditingController();
  Timer timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

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
              Form(
                key: _key,
                child: Container(
                  margin: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: kMaroon, width: 4),
                      color: kIndigo,
                      borderRadius: BorderRadius.all(Radius.circular(35))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SizedBox(height: 25),
                        CircleAvatar(
                            radius: 70,
                            child: Icon(Icons.email_outlined,
                                size: 100, color: Colors.white)),
                        SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: DynamicTextField(
                              myValidator: (value) {
                                if (value.isEmpty) {
                                  return 'Email is required.';
                                }
                                if (!value.contains('@')) {
                                  return 'Email is invalid';
                                }
                                if (!value.contains('.')) {
                                  return 'Email is invalid';
                                }
                              },
                              myController: _emailController,
                              preferredInput: TextInputType.emailAddress,
                              preIcon: Icon(
                                Icons.email_rounded,
                                color: Colors.white,
                              ),
                              label: 'Enter Email...'),
                        ),
                        SizedBox(height: 25),
                        Center(
                          child: Text('Press button below to send reset code.',
                              textDirection: TextDirection.ltr,
                              style: kFlatButton),
                        ),
                        SizedBox(height: 25),
                        SizedBox(height: 25),
                        CustomButton1(
                          yourConstraints:
                              BoxConstraints.expand(height: 60, width: 320),
                          whenPressed: () {
                            if (_key.currentState.validate()) {
                              sendResetCode();
                            }
                          },
                          colorChoice: kBLue,
                          widgetChoice: Center(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Send Code',
                                    style: kButton,
                                  ),
                                  SizedBox(width: 15),
                                  Icon(
                                    Icons.verified_user_outlined,
                                    color: Colors.white,
                                    size: 45,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Center(
                            child: Text('Login ?',
                                textDirection: TextDirection.ltr,
                                style: kFlatButton),
                          ),
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
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

  void sendResetCode() {
    _controller.sendUserPasswordForgotEmail(_emailController.text.trim());
    timer = Timer.periodic(Duration(seconds: 10), (timer) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
          (route) => false);
    });
  }
}
