import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rideboard/Assistants/assistantmethods.dart';
import 'package:rideboard/Assistants/geoFireAssistants.dart';
import 'package:rideboard/main.dart';
import 'package:rideboard/models/nearbyAvailableDrivers.dart';
import 'package:rideboard/ui/Screens/User%20Screens/UserRatingScreen.dart';
import 'package:rideboard/ui/components/Configmaps.dart';
import 'package:rideboard/models/DirectionDetails.dart';
import 'package:rideboard/services/appData.dart';
import 'package:rideboard/ui/components/UserDrawer.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:rideboard/ui/components/custom_button.dart';
import 'package:rideboard/ui/components/divider.dart';
import 'package:rideboard/ui/components/noAvailableDriver.dart';
import 'package:rideboard/ui/components/progressIndicator.dart';
import 'package:rideboard/ui/components/riderCollectfare.dart';
import 'package:url_launcher/url_launcher.dart';

GoogleMapController _myGoogleMapController;

final CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

class RiderPage extends StatefulWidget {
  @override
  _RiderPageState createState() => _RiderPageState();
}

changeMapMode() {
  getJSONFile('assets/mapTheme.json').then(setMapStyle);
}

Future<String> getJSONFile(String path) async {
  return await rootBundle.loadString(path);
}

void setMapStyle(String mapStyle) {
  _myGoogleMapController.setMapStyle(mapStyle);
}

class _RiderPageState extends State<RiderPage> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DirectionDetails tripDirectionDetails;
  List<LatLng> plineCoordinates = [];
  Set<Polyline> polylineSet = {};
  bool isMapCreated = false;
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  String userId = currentfirebaseUser == null ? '' : currentfirebaseUser.uid;

  double searchContainerHeight = 300.0;
  double bottomPaddingofMap = 0;
  double rideDetailsContainer = 0;
  double requestRideContainerHeight = 0;
  double driverDetailsContainerHeight = 0;
  Position currentPosition;
  BitmapDescriptor nearByIcon;
  bool drawerOpen = true;
  bool findRide = true;
  bool isRequestingPositionDetails = false;
  var geoLocator = Geolocator();
  DatabaseReference rideRequestRef;
  bool nearbyAvailableDriverKeysLoaded = false;
  List<NearbyAvailableDrivers> availableDrivers;
  String state = "normal";
  StreamSubscription<Event> rideStreamSubscription;
  String firstname = 'Rider';
  String phoNe;
  String paymentType;
  String lastname, email, carColor, carModel, carNumber = 'String';
  List<String> paymentTypes = ['Cash', 'Card'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssistantMethods.getCurrentOnlineUserInfo();
    _fetchusername();
  }

  _fetchusername() async {
    usersRef
        .child(currentfirebaseUser == null ? '' : currentfirebaseUser.uid)
        .onValue
        .listen((event) {
      var firstName = event.snapshot.value["firstname"];
      var lastName = event.snapshot.value["lastname"];
      var phone = event.snapshot.value["Phone"];
      var emessage = event.snapshot.value["Email"];

      if (event.snapshot == null) {
        setState(() {
          firstname = firstname;
          phoNe = phoNe;
          email = email;
          lastname = lastname;
        });
      } else {
        setState(() {
          firstname = firstName;
          phoNe = phone;
          email = emessage;
          lastname = lastName;
        });
      }
    });
  }

  void _restartApp() async {
    FlutterRestart.restartApp();
  }

  void saveRideRequest() {
    rideRequestRef =
        FirebaseDatabase.instance.reference().child("Ride Requests").push();

    var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;

    Map pickUpLocMap = {
      "latitude": pickUp.latitude.toString(),
      "longitude": pickUp.longitude.toString(),
    };

    Map dropOffLocMap = {
      "latitude": dropOff.latitude.toString(),
      "longitude": dropOff.longitude.toString(),
    };

    var rideInfoMap = {
      "driver_id": "waiting",
      "payment_method": "cash",
      "pickup": pickUpLocMap,
      "dropoff": dropOffLocMap,
      "created_at": DateTime.now().toString(),
      "rider_name": '$firstname $lastname',
      "rider_phone": phoNe,
      "pickup_address": pickUp.placeName,
      "dropoff_address": dropOff.placeName,
    };

    rideRequestRef.set(rideInfoMap);
    rideStreamSubscription = rideRequestRef.onValue.listen((event) async {
      if (event.snapshot.value == null) {
        return;
      }
      if (event.snapshot.value["car_details"] != null) {
        setState(() {
          carDetailsDriver = event.snapshot.value["car_details"].toString();
        });
      }
      if (event.snapshot.value["driver_name"] != null) {
        setState(() {
          driverName = event.snapshot.value["driver_name"].toString();
        });
      }
      if (event.snapshot.value["driver_phone"] != null) {
        setState(() {
          driverphone = event.snapshot.value["driver_phone"].toString();
        });
      }
      if (event.snapshot.value["driver_location"] != null) {
        double driverLat = double.parse(
            event.snapshot.value["driver_location"]["latitude"].toString());
        double driverLng = double.parse(
            event.snapshot.value["driver_location"]["longitude"].toString());
        LatLng driverCurrentLocation = LatLng(driverLat, driverLng);

        if (statusRide == "accepted") {
          updateRideTimeToPickUpLoc(driverCurrentLocation);
        } else if (statusRide == "onride") {
          updateRideTimeToDropOffLoc(driverCurrentLocation);
        } else if (statusRide == "arrived") {
          setState(() {
            rideStatus = "Driver has Arrived.";
          });
        }
      }
      if (event.snapshot.value["status"] != null) {
        statusRide = event.snapshot.value["status"].toString();
      }
      if (statusRide == "accepted") {
        displayDriverDetailsContainer();
        Geofire.stopListener();
        deleteGeofileMarkers();
      }

      if (statusRide == "ended") {
        if (event.snapshot.value["fares"] != null) {
          int fare = int.parse(event.snapshot.value["fares"].toString());
          var res = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => RiderCollectFareDialog(
              paymentMethod: "cash",
              fareAmount: fare,
            ),
          );

          String driverId = "";
          if (res == "close") {
            if (event.snapshot.value["driver_id"] != null) {
              driverId = event.snapshot.value["driver_id"].toString();
            }
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserRatingScreen(driverId: driverId)));

            rideRequestRef.onDisconnect();
            rideRequestRef = null;
            rideStreamSubscription.cancel();
            rideStreamSubscription = null;
            resetApp();
          }
        }
      }
    });
  }

  void deleteGeofileMarkers() {
    setState(() {
      markersSet
          .removeWhere((element) => element.markerId.value.contains("driver"));
    });
  }

  void updateRideTimeToPickUpLoc(LatLng driverCurrentLocation) async {
    if (isRequestingPositionDetails == false) {
      isRequestingPositionDetails = true;

      var positionUserLatLng =
          LatLng(currentPosition.latitude, currentPosition.longitude);
      var details = await AssistantMethods.obtainPlaceDirectionDetails(
          driverCurrentLocation, positionUserLatLng);
      if (details == null) {
        return;
      }
      setState(() {
        rideStatus = "Driver on the way! - " + details.durationText;
      });

      isRequestingPositionDetails = false;
    }
  }

  void updateRideTimeToDropOffLoc(LatLng driverCurrentLocation) async {
    if (isRequestingPositionDetails == false) {
      isRequestingPositionDetails = true;

      var dropOff =
          Provider.of<AppData>(context, listen: false).dropOffLocation;
      var dropOffUserLatLng = LatLng(dropOff.latitude, dropOff.longitude);

      var details = await AssistantMethods.obtainPlaceDirectionDetails(
          driverCurrentLocation, dropOffUserLatLng);
      if (details == null) {
        return;
      }
      setState(() {
        rideStatus = "Let's Go! - " + details.durationText;
      });

      isRequestingPositionDetails = false;
    }
  }

  void cancelRideRequest() {
    rideRequestRef.remove();
    setState(() {
      state = "normal";
    });
  }

  void displayRequestRideContainer() {
    setState(() {
      requestRideContainerHeight = 300;
      rideDetailsContainer = 0;
      bottomPaddingofMap = 300;
    });

    saveRideRequest();
  }

  resetApp() {
    setState(() {
      searchContainerHeight = 300;
      rideDetailsContainer = 0;
      bottomPaddingofMap = 300.0;
      requestRideContainerHeight = 0;

      polylineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      plineCoordinates.clear();
      statusRide = "";
      driverName = "";
      driverphone = "";
      carDetailsDriver = "";
      rideStatus = "Driver on the way!";
      driverDetailsContainerHeight = 0.0;
    });

    locatePosition(context);
  }

  void displayRideDetailsContainer() async {
    await getPlaceDirection();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainer = 300;
      bottomPaddingofMap = 300.0;
      findRide = false;
    });
  }

  void locatePosition(BuildContext context) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latlangPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latlangPosition, zoom: 14);

    _myGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String address =
        await AssistantMethods.searchCoordinateAddress(position, context);
    print('This is your address::' + address);
    initGeorfireListener();
    AssistantMethods.retrieveRiderHistoryInfo(context);
  }

  void displayDriverDetailsContainer() {
    setState(() {
      requestRideContainerHeight = 0.0;
      rideDetailsContainer = 0.0;
      bottomPaddingofMap = 295.0;
      driverDetailsContainerHeight = 285.0;
    });
  }

  var _streamUsers = usersRef.reference();

  @override
  Widget build(BuildContext context) {
    if (isMapCreated) {
      changeMapMode();
      createIconMarker();
    }

    return Scaffold(
        drawer: SafeArea(
          child: UserDrawer(),
        ),
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
                polylines: polylineSet,
                markers: markersSet,
                circles: circlesSet,
                onMapCreated: (GoogleMapController controller) {
                  _myGoogleMapController = controller;
                  changeMapMode();
                  isMapCreated = true;
                  locatePosition(context);

                  setState(() {
                    bottomPaddingofMap = 300;
                  });
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedSize(
                  vsync: this,
                  duration: new Duration(milliseconds: 160),
                  curve: Curves.bounceIn,
                  child: Container(
                    height: searchContainerHeight,
                    decoration: BoxDecoration(
                        color: kthemeColor.withOpacity(0.4),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kthemeColor.withOpacity(0.4),
                            blurRadius: 16,
                            offset: Offset(0.7, 0.7),
                            spreadRadius: 0.5,
                          )
                        ]),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 6.0,
                          ),
                          Row(
                            children: [
                              SizedBox(width: 14),
                              Text('Hi, $firstname', style: ktextTheme3),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              Text(' Where are you heading to?',
                                  style: ktextTheme3),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          GestureDetector(
                            onTap: () async {
                              var res =
                                  await Navigator.pushNamed(context, '/Search');

                              if (res == 'obtainDirection') {
                                displayRideDetailsContainer();
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                        width: 2.0, color: Colors.purple),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.purple.withOpacity(0.4),
                                        blurRadius: 16,
                                        offset: Offset(0.7, 0.7),
                                        spreadRadius: 0.5,
                                      )
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.search,
                                          color: Colors.purple, size: 40),
                                      SizedBox(height: 10),
                                      Text("Search Destination",
                                          style: ktextTheme3)
                                    ],
                                  ),
                                )),
                          ),
                          SizedBox(height: 24.0),
                          Row(
                            children: [
                              SizedBox(
                                width: 9,
                              ),
                              Icon(Icons.home, color: Colors.purple, size: 40),
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Text(
                                        Provider.of<AppData>(context)
                                                    .pickUpLocation !=
                                                null
                                            ? Provider.of<AppData>(context)
                                                .pickUpLocation
                                                .placeName
                                            : "Add Home",
                                        style: ktextTheme4),
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text('Home Address', style: ktextTheme3)
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 10.0),
                          MyDivider(),
                          SizedBox(height: 16.0),
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Icon(Icons.work, color: Colors.purple, size: 30),
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Add Work', style: ktextTheme4),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text('Work Address', style: ktextTheme3)
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 32.0,
                left: 22.0,
                child: Container(
                  child: FloatingActionButton(
                    backgroundColor: kthemeColor.withOpacity(0.7),
                    child: Icon(
                      Icons.menu,
                      size: 28,
                    ),
                    onPressed: () => _scaffoldKey.currentState.openDrawer(),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 160),
                  curve: Curves.bounceIn,
                  child: Container(
                    height: rideDetailsContainer,
                    decoration: BoxDecoration(
                      color: kthemeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: kthemeColor.withOpacity(0.6),
                          blurRadius: 16.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 17.0),
                      child: Column(
                        children: [
                          Container(
                              width: double.infinity,
                              color: kthemeColor.withOpacity(0.1),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset('assets/car.png',
                                            height: 120.0, width: 100.0),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Car', style: ktextTheme6),
                                            Text(
                                                (tripDirectionDetails != null)
                                                    ? tripDirectionDetails
                                                        .distanceText
                                                    : '',
                                                style: ktextTheme6)
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(height: 15),
                                        Text(
                                            ((tripDirectionDetails != null
                                                ? '\$${AssistantMethods.calculateFares(tripDirectionDetails)}'
                                                : '')),
                                            style: ktextTheme7),
                                        SizedBox(height: 20),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                          SizedBox(height: 5),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Icon(FontAwesomeIcons.moneyBill,
                                          size: 25.0, color: Colors.white),
                                      SizedBox(width: 15),
                                      DropdownButton(
                                        iconSize: 40,
                                        hint: Text(
                                          'Pay',
                                          style: ktextTheme3,
                                          textAlign: TextAlign.center,
                                        ),
                                        value: paymentType,
                                        dropdownColor: kthemeColor,
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.white,
                                          size: 36,
                                        ),
                                        style: ktextTheme3,
                                        onChanged: (newValue) {
                                          setState(() {
                                            paymentType = newValue;
                                          });
                                        },
                                        items: paymentTypes.map((payment) {
                                          return DropdownMenuItem(
                                            child: Center(
                                                child: new Text(payment)),
                                            value: payment,
                                          );
                                        }).toList(),
                                      ),
                                    ]),
                                    GestureDetector(
                                      onTap: () {
                                        resetApp();
                                      },
                                      child: Text(
                                          (findRide)
                                              ? 'Cancel Ride'
                                              : 'Cancel Ride',
                                          style: ktextTheme6),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: CustomButton1(
                              yourConstraints:
                                  BoxConstraints.expand(width: 390, height: 80),
                              colorChoice: Colors.purple,
                              widgetChoice: Padding(
                                padding: EdgeInsets.all(17.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Request', style: kCustomButton2),
                                    Icon(FontAwesomeIcons.carSide,
                                        color: Colors.white, size: 40),
                                  ],
                                ),
                              ),
                              whenPressed: () {
                                setState(() {
                                  state = "requesting";
                                });
                                displayRequestRideContainer();
                                availableDrivers =
                                    GeoFireAssistant.nearByAvailableDriversList;
                                searchNearestDriver();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                    height: requestRideContainerHeight,
                    decoration: BoxDecoration(
                      color: kthemeColor.withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 0.5,
                            blurRadius: 16.0,
                            color: kthemeColor.withOpacity(0.8),
                            offset: Offset(0.7, 0.7))
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                              width: double.infinity,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                child: FadeAnimatedTextKit(
                                  repeatForever: true,
                                  text: ['Finding Ride', 'Please Wait...'],
                                  onTap: () {
                                    print('Tap Event');
                                  },
                                  textStyle: kAnimationText,
                                  textAlign: TextAlign.center,
                                ),
                              )),
                          SizedBox(height: 5),
                          GestureDetector(
                            onTap: () {
                              cancelRideRequest();
                              resetApp();
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: kthemeColor,
                                borderRadius: BorderRadius.circular(26.0),
                                border:
                                    Border.all(width: 4.0, color: Colors.white),
                              ),
                              child: Icon(Icons.close,
                                  size: 26.0, color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                              width: double.infinity,
                              child: Center(
                                  child:
                                      Text('Cancel Ride', style: ktextTheme3)))
                        ],
                      ),
                    )),
              ), //Display Assigned Driver Info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    color: kthemeColor.withOpacity(0.7),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 0.5,
                        blurRadius: 16.0,
                        color: Colors.purple,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  height: driverDetailsContainerHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 6.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              rideStatus,
                              textAlign: TextAlign.center,
                              style: ktextTheme3,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 22.0,
                        ),
                        Divider(
                          height: 2.0,
                          thickness: 2.0,
                        ),
                        SizedBox(
                          height: 22.0,
                        ),
                        Text(
                          carDetailsDriver,
                          style: ktextTheme3,
                        ),
                        Text(
                          driverName,
                          style: ktextTheme3,
                        ),
                        SizedBox(
                          height: 22.0,
                        ),
                        Divider(
                          height: 2.0,
                          thickness: 2.0,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //call button
                            CustomButton1(
                              yourConstraints:
                                  BoxConstraints.expand(width: 180, height: 60),
                              whenPressed: () async {
                                launch(('tel://$driverphone'));
                              },
                              colorChoice: Colors.purple,
                              widgetChoice: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Call Driver",
                                    style: ktextTheme3,
                                  ),
                                  Icon(
                                    Icons.call,
                                    color: Colors.white,
                                    size: 26.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future<void> getPlaceDirection() async {
    var initialPos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(
        context: context,
        builder: (BuildContext context) =>
            LoadingIndicator(message: 'Please wait...'));

    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);

    setState(() {
      tripDirectionDetails = details;
    });

    Navigator.pop(context);
    print('This is Encoded Points:');
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);
    plineCoordinates.clear();
    if (decodedPolylinePointsResult.isNotEmpty) {
      decodedPolylinePointsResult.forEach((PointLatLng pointLatLng) {
        plineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
          color: Colors.purple,
          polylineId: PolylineId('PolylineID'),
          jointType: JointType.round,
          points: plineCoordinates,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);

      polylineSet.add(polyline);
    });
    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    _myGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow:
            InfoWindow(title: initialPos.placeName, snippet: 'My Location'),
        position: pickUpLatLng,
        markerId: MarkerId('pickUpid'));

    Marker dropOffLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow:
            InfoWindow(title: finalPos.placeName, snippet: 'My Destination'),
        position: dropOffLatLng,
        markerId: MarkerId('dropOffid'));

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
        fillColor: kthemeColor,
        center: pickUpLatLng,
        radius: 20,
        strokeWidth: 4,
        strokeColor: kthemeColor,
        circleId: CircleId('pickUpId'));

    Circle dropOffLocCircle = Circle(
        fillColor: Colors.green,
        center: pickUpLatLng,
        radius: 20,
        strokeWidth: 4,
        strokeColor: Colors.green,
        circleId: CircleId('dropOffId'));

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }

  void initGeorfireListener() {
    Geofire.initialize('availableDrivers');
    //comment
    Geofire.queryAtLocation(
            currentPosition.latitude, currentPosition.longitude, 15)
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyAvailableDrivers nearbyAvailableDrivers =
                NearbyAvailableDrivers();
            nearbyAvailableDrivers.key = map['key'];
            nearbyAvailableDrivers.latitude = map['latitude'];
            nearbyAvailableDrivers.longitude = map['longitude'];
            GeoFireAssistant.nearByAvailableDriversList
                .add(nearbyAvailableDrivers);
            if (nearbyAvailableDriverKeysLoaded == true) {
              updateAvailableDriversOnMap();
            }
            break;

          case Geofire.onKeyExited:
            GeoFireAssistant.removeDriverFromList(map['key']);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            NearbyAvailableDrivers nearbyAvailableDrivers =
                NearbyAvailableDrivers();
            nearbyAvailableDrivers.key = map['key'];
            nearbyAvailableDrivers.latitude = map['latitude'];
            nearbyAvailableDrivers.longitude = map['longitude'];
            GeoFireAssistant.updateDriverNearbyLocation(nearbyAvailableDrivers);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
            updateAvailableDriversOnMap();
            break;
        }
      }
    });
    //comment
  }

  void updateAvailableDriversOnMap() {
    setState(() {
      markersSet.clear();
    });

    Set<Marker> tMakers = Set<Marker>();
    for (NearbyAvailableDrivers driver
        in GeoFireAssistant.nearByAvailableDriversList) {
      LatLng driverAvaiablePosition = LatLng(driver.latitude, driver.longitude);

      Marker marker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverAvaiablePosition,
        icon: nearByIcon,
        rotation: AssistantMethods.createRandomNumber(360),
      );

      tMakers.add(marker);
    }
    setState(() {
      markersSet = tMakers;
    });
  }

  void createIconMarker() {
    if (nearByIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "assets/car-icon.png")
          .then((value) {
        nearByIcon = value;
      });
    }
  }

  void searchNearestDriver() {
    if (availableDrivers.length == 0) {
      cancelRideRequest();
      resetApp();
      noDriverFound();
      return;
    }

    var driver = availableDrivers[0];
    notifyDriver(driver);
    availableDrivers.removeAt(0);
  }

  void noDriverFound() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => NoDriverAvailableDialog());
  }

  void notifyDriver(NearbyAvailableDrivers driver) {
    driversRef.child(driver.key).child("newRide").set(rideRequestRef.key);

    driversRef
        .child(driver.key)
        .child("token")
        .once()
        .then((DataSnapshot snap) {
      if (snap.value != null) {
        String token = snap.value.toString();
        AssistantMethods.sendNotificationToDriver(
            token, context, rideRequestRef.key);
      } else {
        return;
      }

      const oneSecondPassed = Duration(seconds: 1);
      var timer = Timer.periodic(oneSecondPassed, (timer) {
        if (state != "requesting") {
          driversRef.child(driver.key).child("newRide").set("cancelled");
          driversRef.child(driver.key).child("newRide").onDisconnect();
          driverRequestTimeOut = 30;
          timer.cancel();
        }

        driverRequestTimeOut = driverRequestTimeOut - 1;

        driversRef.child(driver.key).child("newRide").onValue.listen((event) {
          if (event.snapshot.value.toString() == "accepted") {
            driversRef.child(driver.key).child("newRide").onDisconnect();
            driverRequestTimeOut = 30;
            timer.cancel();
          }
        });

        if (driverRequestTimeOut == 0) {
          driversRef.child(driver.key).child("newRide").set("timeout");
          driversRef.child(driver.key).child("newRide").onDisconnect();
          driverRequestTimeOut = 30;
          timer.cancel();

          searchNearestDriver();
        }
      });
    });
  }
}
