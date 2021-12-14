import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rideboard/ui/Screens/Driver%20Screens/DriverProfileScreen.dart';
import 'package:rideboard/ui/components/Configmaps.dart';
import 'package:rideboard/main.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:rideboard/ui/components/custom_button.dart';
import 'package:rideboard/ui/components/progressIndicator.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({Key key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String firstname = '';
  String eMail = '';
  String pHone = '';
  AssetImage image1;
  AssetImage image2;
  @override
  void initState() {
    super.initState();
    _fetchusername3();
    image1 = AssetImage('assets/PATTERN3.png');
    image2 = AssetImage('assets/my_picture.jpg');
  }

  _fetchusername3() async {
    usersRef
        .child(currentfirebaseUser == null ? '' : currentfirebaseUser.uid)
        .onValue
        .listen((event) {
      var firstName = event.snapshot.value["firstname"];
      var email = event.snapshot.value["Email"];
      var phone = event.snapshot.value["Phone"];

      if (event.snapshot == null) {
        setState(() {
          firstname = firstname;
          eMail = email;
          pHone = phone;
        });
      } else {
        setState(() {
          firstname = firstName;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(image1, context);
    precacheImage(image2, context);
  }

  @override
  Widget build(BuildContext context) {
    image1.resolve(createLocalImageConfiguration(context));
    return Container(
      child: Scaffold(
        backgroundColor: kthemeColor,
        body: Stack(children: [
          SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(image: image1, fit: BoxFit.cover)),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$firstname', style: ktextTheme7),
                Text(title + " Rider", style: ktextTheme5),
                SizedBox(
                  height: 20,
                  width: 200,
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                InfoCard(
                  text: '$pHone',
                  icon: Icons.phone,
                  onPressed: () async {
                    print("this is phone.");
                  },
                ),
                InfoCard(
                  text: '$eMail',
                  icon: Icons.email,
                  onPressed: () async {
                    print("this is email.");
                  },
                ),
                GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return LoadingIndicator(message: 'Signing Out...');
                        });
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Login', ModalRoute.withName('/Choice'));
                  },
                  child: CustomButton1(
                    colorChoice: Colors.purple,
                    yourConstraints:
                        BoxConstraints.expand(width: 180, height: 60),
                    widgetChoice: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Sign Out", style: ktextTheme3),
                          Icon(
                            Icons.follow_the_signs_outlined,
                            color: Colors.white,
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
