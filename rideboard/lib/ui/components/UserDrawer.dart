import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rideboard/main.dart';
import 'package:rideboard/ui/components/Configmaps.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:rideboard/ui/components/custom_button.dart';

class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  String firstname = '';

  _fetchusername2() async {
    usersRef
        .child(currentfirebaseUser == null ? '' : currentfirebaseUser.uid)
        .onValue
        .listen((event) {
      var firstName = event.snapshot.value["firstname"];
      if (event.snapshot == null) {
        setState(() {
          firstname = firstname;
        });
      } else {
        setState(() {
          firstname = firstName;
        });
      }
    });
  }

  Image image1;
  AssetImage image2;
  @override
  void initState() {
    super.initState();
    _fetchusername2();
    image1 = Image.asset(
      'assets/logo.png',
      gaplessPlayback: true,
      scale: 4.5,
    );
    image2 = AssetImage('assets/PATTERN3.png');
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
    return Drawer(
        child: Container(
      child: ListView(
        children: [
          Stack(
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(children: [
                      CircleAvatar(
                          child: Center(
                            child: Text(
                              'Add Image',
                              style: ktextTheme2,
                            ),
                          ),
                          radius: 70),
                      Positioned(
                        bottom: 20.0,
                        right: 20.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/ProfileImageScreen");
                          },
                          child: InkWell(
                            child: Icon(Icons.camera_alt_rounded,
                                color: kthemeColor, size: 28),
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(height: 20),
                    Text(
                      '$firstname',
                      style: ktextTheme8,
                    ),
                  ],
                ),
                height: 230,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(image: image2, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(height: 20),
              ListTile(
                title: new Row(children: [
                  SizedBox(
                    width: 45,
                  ),
                  Text('Profile', style: kiconTexts),
                ]),
                leading: Icon(Icons.account_box, size: 23),
                onTap: () {
                  Navigator.pushNamed(context, '/UserProfile');
                },
              ),
              SizedBox(height: 15),
              ListTile(
                title: new Row(children: [
                  SizedBox(
                    width: 25,
                  ),
                  Text('Ride History', style: kiconTexts),
                ]),
                leading: Icon(Icons.history, size: 23),
                onTap: () {
                  Navigator.pushNamed(context, '/UserRideHistory');
                },
              ),
              SizedBox(height: 15),
              ListTile(
                title: new Row(children: [
                  SizedBox(
                    width: 40,
                  ),
                  Text('Payment', style: kiconTexts),
                ]),
                leading: Icon(Icons.payment_rounded, size: 23),
                onTap: () {},
              ),
              SizedBox(height: 15),
              ListTile(
                  title: new Row(children: [
                    SizedBox(
                      width: 12,
                    ),
                    Text('Switch to Driver', style: kiconTexts),
                  ]),
                  leading: Icon(Icons.history, size: 23),
                  onTap: () {
                    Navigator.pushNamed(context, '/DriverCarInfo');
                    // usersRef
                    //     .child("Users")
                    //     .child(currentfirebaseUser == null
                    //         ? ''
                    //         : currentfirebaseUser.uid)
                    //     .child("Driver's_car_details")
                    //     .once()
                    //     .then((DataSnapshot dataSnapShot) {
                    //   if (dataSnapShot.value != null) {

                    //   } else if (dataSnapShot.value == null) {
                    //     Navigator.pushNamed(context, '/DriverCarInfo');
                    //   }
                    // });
                  }),
              SizedBox(height: 15),
              ListTile(
                title: new Row(children: [
                  SizedBox(
                    width: 45,
                  ),
                  Text('About', style: kiconTexts),
                ]),
                leading: Icon(Icons.settings, size: 23),
                onTap: () {
                  Navigator.pushNamed(context, '/AboutScreen');
                },
              ),
              SizedBox(height: 15),
              ListTile(
                onTap: () {
                  FirebaseAuth.instance.signOut();

                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Login', ModalRoute.withName('/Choice'));
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomButton1(
                      colorChoice: kthemeColor.withOpacity(0.9),
                      yourConstraints:
                          BoxConstraints.expand(width: 180, height: 60),
                      widgetChoice: Text(
                        'Log Out',
                        style: kMyName,
                      ),
                    )
                  ],
                ),
                leading: Icon(Icons.exit_to_app_rounded, size: 23),
              )
            ],
          ),
        ],
      ),
    ));
  }
}
