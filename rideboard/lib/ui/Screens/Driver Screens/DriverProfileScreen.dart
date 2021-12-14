import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:rideboard/ui/components/Configmaps.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:rideboard/ui/components/progressIndicator.dart';
import 'package:rideboard/main.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String driverfirstname = '';
  String driverlastname = '';
  String driverphone = '';
  String driverEmail = '';
  String drivervehColor = '';
  String drivervehModel = '';
  String drivervehNumber = '';

  _fetchusername5() async {
    driversRef
        .child(currentfirebaseUser == null ? '' : currentfirebaseUser.uid)
        .onValue
        .listen((event) {
      var driverfirstName = event.snapshot.value["firstname"];
      var driveremail = event.snapshot.value["Email"];
      var driverPhone = event.snapshot.value["Phone"];
      var driverCarcolor =
          event.snapshot.value["User's_car_details"]["car_color"];
      var driverCarModel =
          event.snapshot.value["User's_car_details"]["car_model"];
      var driverCarNumber =
          event.snapshot.value["User's_car_details"]["car_number"];

      if (event.snapshot == null) {
        setState(() {
          driverfirstname = driverfirstname;
          driverEmail = driverEmail;
          driverphone = driverphone;
          driverlastname = driverlastname;
          drivervehColor = driverCarcolor;
          drivervehModel = driverCarModel;
          drivervehNumber = driverCarNumber;
        });
      } else {
        setState(() {
          driverfirstname = driverfirstName;
          driverlastname = driverlastname;
          driverphone = driverPhone;
          driverEmail = driveremail;
          drivervehColor = driverCarcolor;
          drivervehModel = driverCarModel;
          drivervehNumber = driverCarNumber;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchusername5();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kthemeColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(driverfirstname, style: ktextTheme7),
            Text(title + " driver", style: ktextTheme5),
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
              text: '$driverphone',
              icon: Icons.phone,
              onPressed: () async {
                print("this is phone.");
              },
            ),
            InfoCard(
              text: '$driverEmail',
              icon: Icons.email,
              onPressed: () async {
                print("this is email.");
              },
            ),
            InfoCard(
              text:
                  drivervehColor + " " + drivervehModel + " " + drivervehNumber,
              icon: Icons.car_repair,
              onPressed: () async {
                print("this is car info.");
              },
            ),
            GestureDetector(
              onTap: () {
                Geofire.removeLocation(
                    currentfirebaseUser != null ? currentfirebaseUser.uid : '');
                rideRequestsRef.onDisconnect();
                rideRequestsRef.remove();
                rideRequestsRef = null;

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
              child: Card(
                color: Colors.purple,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 110.0),
                child: ListTile(
                  trailing: Icon(
                    Icons.follow_the_signs_outlined,
                    color: Colors.white,
                  ),
                  title: Text("Sign out",
                      textAlign: TextAlign.center, style: ktextTheme3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class InfoCard extends StatelessWidget {
  final String text;
  final IconData icon;
  Function onPressed;

  InfoCard({
    this.text,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.purple,
          ),
          title: Text(text, style: ktextTheme9),
        ),
      ),
    );
  }
}
