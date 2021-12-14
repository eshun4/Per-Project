import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:rideboard/main.dart';
import 'package:rideboard/ui/Screens/Driver%20Screens/Car_InfoScreen.dart';
import 'package:rideboard/ui/components/progressIndicator.dart';
import '../../components/constants.dart';
import '../../components/text_field.dart';
import '../../components/custom_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final GlobalKey<FormState> _key = GlobalKey<FormState>();

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Image image1;
  AssetImage image2;
  @override
  void initState() {
    super.initState();
    image1 = Image.asset(
      'assets/logo.png',
      gaplessPlayback: true,
      scale: 4.5,
    );
    image2 = AssetImage('assets/Wallpaper-1.png');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(image1.image, context);
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
            child: Container(
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
                child: SafeArea(
                  child: Scaffold(
                    body: SingleChildScrollView(
                      child: Container(
                        child: Form(
                          key: _key,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 7),
                              image1,
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.purple.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        Container(
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
                                              myController: emailController,
                                              preferredInput:
                                                  TextInputType.emailAddress,
                                              preIcon: Icon(
                                                Icons.email_rounded,
                                                color: Colors.white,
                                              ),
                                              label: 'Enter Email'),
                                        ),
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
                                            preIcon: Icon(
                                                Icons.lock_open_rounded,
                                                color: Colors.white),
                                            label: 'Enter Password'),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(15),
                                              child: GestureDetector(
                                                child: Text(
                                                  'Forgot Password?',
                                                  style: kFlatbutton,
                                                ),
                                                onTap: () {},
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        CustomButton1(
                                          yourConstraints:
                                              BoxConstraints.expand(
                                                  height: 60, width: 290),
                                          colorChoice:
                                              kthemeColor.withOpacity(0.8),
                                          whenPressed: () {
                                            if (_key.currentState.validate()) {
                                              loginAndAuthenticateUser(context);
                                              // _restartApp();
                                            }
                                          },
                                          widgetChoice: Center(
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text('Sign In',
                                                      style: kCustomButton2),
                                                  SizedBox(width: 6),
                                                  Icon(
                                                    Icons.login,
                                                    color: Colors.white,
                                                    size: 35,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        CustomButton1(
                                          yourConstraints:
                                              BoxConstraints.expand(
                                                  height: 60, width: 290),
                                          whenPressed: () {
                                            Navigator.of(context)
                                                .pushNamed('/SignUp');
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
                                                    'Sign Up',
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
                                        ),
                                      ],
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
              ),
            ),
          )
        ],
      ),
    );
  }

  //Login user into account
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingIndicator(
            message: "Signin In...",
          );
        });

    // ignore: deprecated_member_use
    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, "/Rider", (route) => false);
          displayToastMessage("Login Successful!...Please Wait...", context);
          _restartApp();
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage(
              "Record doesn't exist. Please create new user.", context);
        }
      });
    } else {
      Navigator.pop(context);
      displayToastMessage("Error Occured, can not be Signed-in.", context);
    }
  }

  void _restartApp() async {
    FlutterRestart.restartApp();
  }
}
