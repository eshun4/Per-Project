import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rideboard/services/Navigation%20Settings/User%20Navigation%20Settings/route_generator.dart';
import 'package:rideboard/services/appData.dart';
import 'package:rideboard/ui/Screens/User%20Screens/Login_Screen.dart';
import 'package:rideboard/ui/components/Configmaps.dart';
import 'ui/components/constants.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  currentfirebaseUser = FirebaseAuth.instance.currentUser;
  runApp(Rideboard());
}

String _fdbUrl1 = "https://rideboard-9d87b-default-rtdb.firebaseio.com/";
DatabaseReference usersRef =
    FirebaseDatabase(databaseURL: _fdbUrl1).reference().child("Users");
DatabaseReference driversRef =
    FirebaseDatabase(databaseURL: _fdbUrl1).reference().child("Drivers");
DatabaseReference newRequestsRef =
    FirebaseDatabase.instance.reference().child("Ride Requests");

DatabaseReference rideRequestsRef = FirebaseDatabase.instance
    .reference()
    .child("Drivers")
    .child(currentfirebaseUser != null ? currentfirebaseUser.uid : '')
    .child("newRide");

class Rideboard extends StatefulWidget {
  @override
  _RideboardState createState() => _RideboardState();
}

class _RideboardState extends State<Rideboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        initialRoute: currentfirebaseUser == null ? "/Login" : "/Rider",
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: kthemeColor.withOpacity(0.2),
          textTheme: ktextTheme,
        ),
      ),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  //Initializes the Timer
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 4),
      () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: kthemeColor,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/PATTERN3.png',
                  ),
                  fit: BoxFit.cover),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 20),
            Image.asset(
              'assets/logo.png',
              scale: 4.5,
            ),
            Text('Hitch a ride Asap!', style: kSplashScreen),
            SizedBox(height: 30),
            SpinKitWave(
              itemBuilder: (context, index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven ? Color(0xFF0A1768) : Colors.blue,
                  ),
                );
              },
            ),
            SizedBox(
              height: 30,
            ),
            Text('By Kofi Junior Eshun', style: kMyName)
          ],
        )
      ],
    ));
  }
}
