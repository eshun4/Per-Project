import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:rideboard/ui/components/custom_button.dart';
import 'package:rideboard/ui/components/progressIndicator.dart';

class RiderDrawer extends StatelessWidget {
  const RiderDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    CircleAvatar(
                        backgroundImage: AssetImage('assets/my_picture.jpg'),
                        radius: 70),
                    SizedBox(height: 20),
                    Text(
                      'Username',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                height: 230,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/PATTERN3.png'),
                      fit: BoxFit.cover),
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
                onTap: () {},
              ),
              SizedBox(height: 15),
              ListTile(
                title: new Row(children: [
                  SizedBox(
                    width: 45,
                  ),
                  Text('Filters', style: kiconTexts),
                ]),
                leading: Icon(Icons.drag_indicator_rounded, size: 23),
                onTap: () {},
              ),
              SizedBox(height: 15),
              ListTile(
                title: new Row(children: [
                  SizedBox(
                    width: 12,
                  ),
                  Text('Ride/Trip History', style: kiconTexts),
                ]),
                leading: Icon(Icons.history, size: 23),
                onTap: () {},
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
                    width: 40,
                  ),
                  Text('Settings', style: kiconTexts),
                ]),
                leading: Icon(Icons.settings, size: 23),
                onTap: () {},
              ),
              SizedBox(height: 15),
              ListTile(
                title: new Row(children: [
                  SizedBox(
                    width: 12,
                  ),
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
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    CustomButton1(
                      colorChoice: kthemeColor.withOpacity(0.9),
                      yourConstraints:
                          BoxConstraints.expand(width: 120, height: 45),
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
