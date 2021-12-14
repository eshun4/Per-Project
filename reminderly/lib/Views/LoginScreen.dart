import "package:flutter/cupertino.dart";
import 'package:flutter/material.dart';
import 'package:reminderly/Constants/Path_constants.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Controllers/Services/User_services.dart';
import 'package:reminderly/Models/Widgets/ButtonWidget.dart';
import 'package:reminderly/Models/Widgets/TextFields.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reminderly/Views/SendPasswordCodeResetScreen.dart';
import 'package:reminderly/Views/RegisterScreen.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
              kIndigo,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(children: [
          TopClipPath(300, kBLue.withOpacity(0.7), Clipper1()),
          TopClipPath(400, kIndigo.withOpacity(0.2), Clipper1()),
          TopClipPath(500, kMaroon.withOpacity(0.6), Clipper1()),
          Stack(
            alignment: Alignment.center,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Icon(
                      FontAwesomeIcons.clipboardList,
                      color: kIndigo,
                      size: 100,
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
                          child: Column(
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
                                  myController: emailController,
                                  preferredInput: TextInputType.emailAddress,
                                  preIcon: Icon(
                                    Icons.email_rounded,
                                    color: Colors.white,
                                  ),
                                  label: 'Enter Email'),
                              SizedBox(height: 10),
                              PasswordField(
                                  myValidator: (value) {
                                    if (value.length < 6) {
                                      return 'Password should be more than 6 characters.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  myController: passwordController,
                                  preIcon: Icon(Icons.lock_open_rounded,
                                      color: Colors.white),
                                  label: 'Enter Password'),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(15),
                                    child: GestureDetector(
                                      child: Text(
                                        'Forgot Password?',
                                        style: kFlatButton,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SendPasswordResetCodeScreen()));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: kIndigo,
                                spreadRadius: 5,
                                blurRadius: 10.0,
                                offset: Offset(0, 10))
                          ],
                          color: kIndigo,
                          borderRadius: BorderRadius.circular(15)),
                      child: CustomButton1(
                        yourConstraints:
                            BoxConstraints.expand(height: 60, width: 290),
                        colorChoice: kIndigo,
                        whenPressed: () {
                          if (_key.currentState.validate()) {
                            _servicesController.loginUser(
                                emailController.text.trim(),
                                passwordController.text.trim());
                          }
                        },
                        widgetChoice: Center(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Sign In', style: kButton),
                                SizedBox(width: 21),
                                Icon(
                                  FontAwesomeIcons.signature,
                                  color: Colors.white,
                                  size: 45,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: kMaroon,
                              spreadRadius: 5,
                              blurRadius: 10.0,
                              offset: Offset(0, 10))
                        ],
                        color: kIndigo,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: CustomButton1(
                        yourConstraints:
                            BoxConstraints.expand(height: 60, width: 290),
                        whenPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegisterScreen()));
                        },
                        colorChoice: kMaroon,
                        widgetChoice: Center(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sign Up',
                                  style: kButton,
                                ),
                                SizedBox(width: 15),
                                Icon(
                                  FontAwesomeIcons.solidHandshake,
                                  color: Colors.white,
                                  size: 45,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
