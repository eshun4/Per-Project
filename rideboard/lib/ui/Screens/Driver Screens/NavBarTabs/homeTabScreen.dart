import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideboard/Assistants/assistantmethods.dart';
import 'package:rideboard/main.dart';
import 'package:rideboard/models/DirectionDetails.dart';
import 'package:rideboard/models/drivers.dart';
import 'package:rideboard/models/user.dart';
import 'package:rideboard/services/pushNotificationServices.dart';
import 'package:rideboard/ui/Screens/Driver%20Screens/Car_InfoScreen.dart';
import 'package:rideboard/ui/components/Configmaps.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:rideboard/ui/components/custom_button.dart';
import 'package:flutter_restart/flutter_restart.dart';

class DriverApp extends StatefulWidget {
  @override
  _DriverAppState createState() => _DriverAppState();
}

GoogleMapController _myGoogleMapController;

final CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

changeMapMode() {
  getJSONFile('assets/mapTheme.json').then(setMapStyle);
}

Future<String> getJSONFile(String path) async {
  return await rootBundle.loadString(path);
}

void setMapStyle(String mapStyle) {
  _myGoogleMapController.setMapStyle(mapStyle);
}

class _DriverAppState extends State<DriverApp> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DirectionDetails tripDirectionDetails;

  bool isMapCreated = false;

  double searchContainerHeight = 300.0;
  double bottomPaddingofMap = 0;
  double rideDetailsContainer = 0;
  double requestRideContainerHeight = 0;

  bool drawerOpen = true;
  bool findRide = true;
  var geoLocator = Geolocator();

  String driverStatus = 'Offline';
  Color driverStatusColor = kthemeColor.withOpacity(0.7);
  bool isDriverAvailable = false;
  Icon connectIcon = Icon(
    Icons.signal_wifi_off_rounded,
    size: 40,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentDriverInfo();
  }

  getRatings() {
    //update ratings
    driversRef
        .child(currentfirebaseUser.uid)
        .child("ratings")
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        double ratings = double.parse(dataSnapshot.value.toString());
        setState(() {
          starCounter = ratings;
        });

        if (starCounter <= 1.5) {
          setState(() {
            title = "Very Bad";
          });
          return;
        }
        if (starCounter <= 2.5) {
          setState(() {
            title = "Bad";
          });

          return;
        }
        if (starCounter <= 3.5) {
          setState(() {
            title = "Good";
          });

          return;
        }
        if (starCounter <= 4.5) {
          setState(() {
            title = "Very Good";
          });
          return;
        }
        if (starCounter <= 5.0) {
          setState(() {
            title = "Excellent";
          });

          return;
        }
      }
    });
  }

  locatePosition(BuildContext context) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latlangPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latlangPosition, zoom: 14);

    _myGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    // String address =
    //     await AssistantMethods.searchCoordinateAddress(position, context);
    // print('This is your address::' + address);
  }

  void getCurrentDriverInfo() async {
    var currentfirebaseUser = await FirebaseAuth.instance.currentUser;

    usersRef
        .child(currentfirebaseUser.uid)
        .once()
        .then((DataSnapshot dataSnapShot) {
      if (dataSnapShot.value != null) {
        userCurrentInfo = MyUsers.fromDataSnapshot(dataSnapShot);
      }
    });

    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();

    AssistantMethods.retrieveHistoryInfo(context);
    getRatings();
    // getRideType();
  }

  @override
  Widget build(BuildContext context) {
    if (isMapCreated) {
      changeMapMode();
    }
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: bottomPaddingofMap),
              initialCameraPosition: _kGooglePlex,
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              compassEnabled: true,
              buildingsEnabled: true,
              trafficEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _myGoogleMapController = controller;
                changeMapMode();
                isMapCreated = true;
                locatePosition(context);
                // setState(() {
                //   bottomPaddingofMap = 300;
                // });
              },
            ),
            Positioned(
                top: 0,
                right: 120,
                child: CustomButton1(
                    colorChoice: driverStatusColor,
                    yourConstraints:
                        BoxConstraints.expand(width: 230, height: 65),
                    widgetChoice: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          driverStatus,
                          style: ktextTheme7,
                        ),
                        connectIcon,
                      ],
                    ),
                    whenPressed: () {
                      if (isDriverAvailable != true) {
                        makeDriverOnlineNow();
                        getLocationLiveUpdates();

                        setState(() {
                          driverStatusColor = Colors.purple;
                          driverStatus = 'Online';
                          isDriverAvailable = true;
                          connectIcon = Icon(
                            Icons.signal_wifi_4_bar_rounded,
                            size: 40,
                          );
                        });
                        displayToastMessage('Online Now !', context);
                      } else {
                        displayToastMessage('Offline Now !', context);
                        makeDriverOffline();
                        setState(() {
                          driverStatusColor = kthemeColor.withOpacity(0.7);
                          driverStatus = 'Offline';
                          isDriverAvailable = false;
                          connectIcon = Icon(
                            Icons.signal_wifi_off_rounded,
                            size: 40,
                          );
                        });
                      }
                    }))
          ],
        ),
      ),
    );
  }

  void makeDriverOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);

    rideRequestsRef.set("searching");
    rideRequestsRef.onValue.listen((event) {});
  }

  void getLocationLiveUpdates() {
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if (isDriverAvailable == true) {
        Geofire.setLocation(
            currentfirebaseUser.uid, position.latitude, position.longitude);
      }

      LatLng latLng = LatLng(position.latitude, position.longitude);
      _myGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void makeDriverOffline() {
    Geofire.removeLocation(currentfirebaseUser.uid);

    rideRequestsRef.onDisconnect();
    rideRequestsRef.remove();
    rideRequestsRef = null;
    _restartApp();
  }

  void _restartApp() async {
    FlutterRestart.restartApp();
  }
}
