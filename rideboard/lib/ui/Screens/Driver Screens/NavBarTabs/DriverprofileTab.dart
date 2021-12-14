import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rideboard/ui/components/Configmaps.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:rideboard/ui/components/custom_button.dart';
import 'package:rideboard/ui/components/progressIndicator.dart';

class DriverProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Stack(
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/my_picture.jpg'),
                            radius: 70),
                        SizedBox(width: 20),
                        Text(
                          '${userCurrentInfo != null ? userCurrentInfo.firstname : ''}',
                          style: ktextTheme7,
                        ),
                        Text(
                          title + 'driver',
                          style: ktextTheme5,
                        )
                      ],
                    ),
                  ],
                ),
                height: 190,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/PATTERN3.png'),
                      fit: BoxFit.cover),
                ),
              ),
            ],
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: 20),
                ListTile(
                  title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Profile', style: kiconTexts),
                      ]),
                  leading: Icon(Icons.account_box, size: 23),
                  onTap: () {
                    Navigator.pushNamed(context, '/DriverMainProfileScreen');
                  },
                ),
                SizedBox(height: 15),
                ListTile(
                  title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Filters', style: kiconTexts),
                      ]),
                  leading: Icon(Icons.drag_indicator_rounded, size: 23),
                  onTap: () {},
                ),
                SizedBox(height: 15),
                ListTile(
                  title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Ride/Trip History', style: kiconTexts),
                      ]),
                  leading: Icon(Icons.history, size: 23),
                  onTap: () {},
                ),
                SizedBox(height: 15),
                ListTile(
                  title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Payment', style: kiconTexts),
                      ]),
                  leading: Icon(Icons.payment_rounded, size: 23),
                  onTap: () {},
                ),
                SizedBox(height: 15),
                ListTile(
                  title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Settings', style: kiconTexts),
                      ]),
                  leading: Icon(Icons.settings, size: 23),
                  onTap: () {},
                ),
                SizedBox(height: 15),
                ListTile(
                  title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Find a Ride', style: kiconTexts),
                      ]),
                  leading: Icon(Icons.history, size: 23),
                  onTap: () {
                    Navigator.pushNamed(context, '/Rider');
                  },
                ),
                SizedBox(height: 15),
                ListTile(
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
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 40,
                      ),
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
          ),
        ],
      ),
    );
  }
}
