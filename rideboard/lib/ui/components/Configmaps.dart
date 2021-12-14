import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rideboard/models/drivers.dart';
import 'package:rideboard/models/user.dart';

String mapKey = "AIzaSyCdxdoppPUsp6dOTlCgToFJT1T6odg_96s";

User firebaseUser;
MyUsers userCurrentInfo;
User currentfirebaseUser;
StreamSubscription<Position> homeTabPageStreamSubscription;
Position currentPosition;

String statusRide = "";
String carDetailsDriver = "";
String driverName = "";
String driverphone = "";
String rideStatus = 'Driver on the Way!';
double starCounter = 0.0;
String title = "";
String carRideType = "";

StreamSubscription<Position> rideStreamSubscription;
String serverToken =
    "key=AAAAeY4p1BI:APA91bGjJ4vhzy9Jj8j4TSFM38Rpkub7wf46OlRNHVp0h0g9i0P6xSmlX8ZMnQctS6-POgEGh-5IITendnRbb-T-kuhQ9rLVxZxjjnIr6WSlAD0__xnVgfYJ9rn0dXi_Bi6Qll-x3ENz";
int driverRequestTimeOut = 30;
