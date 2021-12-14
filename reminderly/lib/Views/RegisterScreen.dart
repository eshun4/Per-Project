import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Constants/Path_constants.dart';
import 'package:reminderly/Controllers/Services/User_services.dart';
import 'package:reminderly/Models/Widgets/ButtonWidget.dart';
import 'package:reminderly/Models/Widgets/TextFields.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  UserServices _userController = new UserServices();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                SizedBox(height: 50),
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
                                myController: emailController,
                                preferredInput: TextInputType.emailAddress,
                                preIcon: Icon(
                                  Icons.email_rounded,
                                  color: Colors.white,
                                ),
                                label: 'Enter Email'),
                            SizedBox(height: 10),
                            DynamicTextField(
                                myValidator: (value) {
                                  if (value.isEmpty) {
                                    return 'First Name is required.';
                                  }
                                },
                                myController: firstnameController,
                                preferredInput: TextInputType.emailAddress,
                                preIcon: Icon(
                                  FontAwesomeIcons.user,
                                  color: Colors.white,
                                ),
                                label: 'Enter First Name'),
                            SizedBox(height: 10),
                            DynamicTextField(
                                myValidator: (value) {
                                  if (value.isEmpty) {
                                    return 'Last Name is required.';
                                  }
                                },
                                myController: lastnameController,
                                preferredInput: TextInputType.text,
                                preIcon: Icon(
                                  FontAwesomeIcons.userAlt,
                                  color: Colors.white,
                                ),
                                label: 'Enter Last Name'),
                            SizedBox(height: 10),
                            DynamicTextField(
                                myValidator: (value) {
                                  if (value.isEmpty) {
                                    return 'Phone number field cannot be Empty.';
                                  }
                                },
                                myController: phoneController,
                                preferredInput: TextInputType.phone,
                                preIcon: Icon(
                                  FontAwesomeIcons.phoneAlt,
                                  color: Colors.white,
                                ),
                                label: 'Phone'),
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
                                      'Already Have an Account?',
                                      style: kFlatButton,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                CustomButton1(
                  yourConstraints:
                      BoxConstraints.expand(height: 60, width: 290),
                  whenPressed: () {
                    if (_key.currentState.validate()) {
                      _userController.registerUser(
                          firstnameController.text.trim(),
                          lastnameController.text.trim(),
                          emailController.text.trim(),
                          phoneController.text.trim(),
                          passwordController.text);
                    }
                  },
                  colorChoice: kMaroon,
                  widgetChoice: Center(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Register',
                            style: kButton,
                          ),
                          SizedBox(width: 15),
                          Icon(
                            FontAwesomeIcons.handshakeAltSlash,
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
      )),
    );
  }
}
