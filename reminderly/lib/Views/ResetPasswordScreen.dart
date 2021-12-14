import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Constants/Path_constants.dart';
import 'package:reminderly/Controllers/Services/User_services.dart';
import 'package:reminderly/Models/Widgets/ButtonWidget.dart';
import 'package:reminderly/Models/Widgets/TextFields.dart';
import 'package:reminderly/Views/LoginScreen.dart';

// ignore: must_be_immutable
class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmationController =
      TextEditingController();
  TextEditingController _tokenController = TextEditingController();
  UserServices _userController = new UserServices();

  Timer timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kMaroon,
                kBLue,
                kIndigo,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        ClipPath(
          clipper: MiddleCurve(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: kMaroon,
                    spreadRadius: 5,
                    blurRadius: 10.0,
                    offset: Offset(5, 18))
              ],
              gradient: LinearGradient(colors: [
                kBLue.withOpacity(0.4),
                kIndigo.withOpacity(0.7),
                kMaroon.withOpacity(0.9),
              ], begin: Alignment.centerLeft, end: Alignment.centerRight),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(40),
                child: Form(
                  key: _key,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        border: Border.all(color: kMaroon, width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: kMaroon,
                              spreadRadius: 5,
                              blurRadius: 10.0,
                              offset: Offset(5, 18))
                        ],
                        color: kIndigo,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DynamicTextField(
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
                          SizedBox(height: 10),
                          PasswordField(
                              myValidator: (value) {
                                if (value.length < 6) {
                                  return 'Password should be more than 6 characters.';
                                } else {
                                  return null;
                                }
                              },
                              myController: _passwordController,
                              preIcon: Icon(Icons.lock_open_rounded,
                                  color: Colors.white),
                              label: 'Enter Password...'),
                          SizedBox(height: 10),
                          PasswordField(
                              myValidator: (value) {
                                if (value.length < 6) {
                                  return 'Password should be more than 6 characters.';
                                } else if (value.isEmpty) {
                                  return 'This field cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                              myController: _passwordConfirmationController,
                              preIcon: Icon(Icons.lock_open_rounded,
                                  color: Colors.white),
                              label: 'Confirm Password...'),
                          SizedBox(height: 10),
                          DynamicTextField(
                              myValidator: (value) {
                                if (value.isEmpty) {
                                  return 'This field cannot be empty';
                                }
                              },
                              myController: _tokenController,
                              preferredInput: TextInputType.emailAddress,
                              preIcon: Icon(
                                Icons.email_rounded,
                                color: Colors.white,
                              ),
                              label: 'Paste Code from Email...'),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              CustomButton1(
                yourConstraints: BoxConstraints.expand(height: 60, width: 340),
                whenPressed: () {
                  if (_key.currentState.validate()) {
                    _userController.resetUserPassword(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                        _passwordConfirmationController.text.trim(),
                        _tokenController.text.trim());
                    timer = Timer.periodic(Duration(seconds: 10), (timer) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (route) => false);
                    });
                  }
                },
                colorChoice: kMaroon,
                widgetChoice: Center(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Reset Password',
                          style: kButton,
                        ),
                        SizedBox(width: 15),
                        Icon(
                          Icons.restore,
                          color: Colors.white,
                          size: 45,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
