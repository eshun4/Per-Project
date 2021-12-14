import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:rideboard/main.dart';
import 'package:rideboard/models/user.dart';
import 'package:rideboard/ui/Screens/Driver%20Screens/Car_InfoScreen.dart';
import 'package:rideboard/ui/components/Configmaps.dart';
import 'package:rideboard/ui/components/progressIndicator.dart';
import '../../components/constants.dart';
import '../../components/text_field.dart';
import '../../components/custom_button.dart';
import '../../components/linktexts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

final GlobalKey<FormState> _key = GlobalKey<FormState>();
TextEditingController firstnameController = TextEditingController();
TextEditingController lastnameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController phoneController = TextEditingController();

class _SignUpPageState extends State<SignUpPage> {
  AssetImage image2;
  @override
  void initState() {
    super.initState();

    image2 = AssetImage('assets/Wallpaper-3.png');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(image2, context);
  }

  @override
  Widget build(BuildContext context) {
    image2.resolve(createLocalImageConfiguration(context));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kthemeColor.withOpacity(0.1),
        textTheme: ktextTheme,
      ),
      home: Stack(
        children: [
          Container(
            color: kthemeColor,
            height: double.infinity,
            width: double.infinity,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(image: image2, fit: BoxFit.cover),
              ),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Container(
              child: Material(
                color: kthemeColor.withOpacity(0.3),
                child: Scaffold(
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Form(
                                  key: _key,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        DynamicTextField(
                                            myValidator: (value) {
                                              if (value.isEmpty) {
                                                return 'Name is required.';
                                              }
                                            },
                                            myController: firstnameController,
                                            preferredInput: TextInputType.text,
                                            preIcon: Icon(
                                              FontAwesomeIcons.user,
                                              color: Colors.white,
                                            ),
                                            label: 'First Name'),
                                        SizedBox(height: 5),
                                        DynamicTextField(
                                            myValidator: (value) {
                                              if (value.isEmpty) {
                                                return 'Name is required.';
                                              }
                                            },
                                            myController: lastnameController,
                                            preferredInput: TextInputType.text,
                                            preIcon: Icon(
                                              FontAwesomeIcons.user,
                                              color: Colors.white,
                                            ),
                                            label: 'Last Name'),
                                        SizedBox(height: 5),
                                        DynamicTextField(
                                            myValidator: (value) {
                                              if (value.isEmpty) {
                                                return 'Email is required.';
                                              }
                                              if (!value.contains('@')) {
                                                return 'Email address is not valid';
                                              }
                                              if (!value.contains('.')) {
                                                return 'Email address is not valid';
                                              }
                                            },
                                            myController: emailController,
                                            preferredInput: TextInputType.text,
                                            preIcon: Icon(
                                              Icons.email_rounded,
                                              color: Colors.white,
                                            ),
                                            label: 'Enter Email'),
                                        SizedBox(height: 5),
                                        DynamicTextField(
                                            myValidator: (value) {
                                              if (value.isEmpty) {
                                                return 'Phone Number is required.';
                                              } else {
                                                return null;
                                              }
                                            },
                                            myController: phoneController,
                                            preferredInput: TextInputType.phone,
                                            preIcon: Icon(
                                              FontAwesomeIcons.phoneAlt,
                                              color: Colors.white,
                                            ),
                                            label: 'Phone Number '),
                                        SizedBox(height: 5),
                                        PasswordField(
                                            myValidator: (value) {
                                              if (value.isEmpty) {
                                                return "Password is required";
                                              }
                                            },
                                            myController: passwordController,
                                            preIcon: Icon(
                                                Icons.lock_open_rounded,
                                                color: Colors.white),
                                            label: 'Enter Password'),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(15),
                                              child: GestureDetector(
                                                child: Text(
                                                  'Already have an account?',
                                                  style: kFlatbutton,
                                                ),
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1),
                                        CustomButton1(
                                          yourConstraints:
                                              BoxConstraints.expand(
                                                  height: 60, width: 290),
                                          whenPressed: () {
                                            if (_key.currentState.validate()) {
                                              registerNewUser(context);
                                            }
                                          },
                                          colorChoice:
                                              Colors.purple.withOpacity(0.8),
                                          widgetChoice: Center(
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Register',
                                                    style: kCustomButton2,
                                                  ),
                                                  SizedBox(width: 6),
                                                  Icon(
                                                    Icons.app_registration,
                                                    color: Colors.white,
                                                    size: 35,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // User Signup
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingIndicator(
            message: " Creating Account...",
          );
        });

    // ignore: deprecated_member_use
    final UserCredential firebaseUser = await _firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    });

    if (firebaseUser != null) //user created
    {
      //save user info to database
      Map userDataMap = {
        "firstname": firstnameController.text.trim(),
        "lastname": lastnameController.text.trim(),
        "Email": emailController.text.trim(),
        "Phone": phoneController.text.trim(),
      };

      usersRef.child(firebaseUser.user.uid).set(userDataMap);
      driversRef.child(firebaseUser.user.uid).set(userDataMap);

      displayToastMessage(
          "Congratulations, your account has been created.", context);

      Navigator.pushNamedAndRemoveUntil(
          context, '/GettingStarted', (route) => false);
    } else {
      Navigator.pop(context);
      //error occured - display error msg
      displayToastMessage("New user account has not been Created.", context);
    }
  }
}
