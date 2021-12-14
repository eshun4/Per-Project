import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideboard/Assistants/assistantmethods.dart';
import 'package:rideboard/main.dart';
import 'package:rideboard/models/rideDetails.dart';
import 'package:rideboard/services/mapAssistantKit.dart';
import 'package:rideboard/ui/components/Configmaps.dart';
import 'package:rideboard/ui/components/collectFareDialog.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:rideboard/ui/components/custom_button.dart';
import 'package:rideboard/ui/components/progressIndicator.dart';

class NewRideScreen extends StatefulWidget {
  final RideDetails rideDetails;
  NewRideScreen({this.rideDetails});

  @override
  _NewRideScreenState createState() => _NewRideScreenState();
}

bool isMapCreated = false;
final CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);
Completer<GoogleMapController> _controllerGoogleMap = Completer();
GoogleMapController _newrideGoogleMapController;
changeMapMode() {
  getJSONFile('assets/mapTheme.json').then(setMapStyle);
}

Future<String> getJSONFile(String path) async {
  return await rootBundle.loadString(path);
}

void setMapStyle(String mapStyle) {
  _newrideGoogleMapController.setMapStyle(mapStyle);
}

class _NewRideScreenState extends State<NewRideScreen> {
  Set<Marker> markersSet = Set<Marker>();
  Set<Circle> circleSet = Set<Circle>();
  Set<Polyline> polyLineSet = Set<Polyline>();
  List<LatLng> polylineCorOrdinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double mapPaddingFromBottom = 0;
  var geoLocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
  BitmapDescriptor animatingMarkerIcon;
  Position myPosition;
  String status = "accepted";
  String durationRide = "";
  bool isRequestingDirection = false;
  String btnTitle = "Arrived";
  Color btnColor = Colors.purple;
  Timer timer;
  int durationCounter = 0;
  String firstname,
      lastname,
      email,
      phone,
      carColor,
      carModel,
      carNumber,
      dRiverID;

  @override
  void initState() {
    super.initState();
    acceptRideRequest();
    // _fetchdriverInfo();
  }

  // _fetchdriverInfo() async {
  //   usersRef
  //       .child(currentfirebaseUser == null ? '' : currentfirebaseUser.uid)
  //       .onValue
  //       .listen((event) {
  //     var firstName = event.snapshot.value["firstname"];
  //     var lastName = event.snapshot.value["lastname"];
  //     var phone = event.snapshot.value["Phone"];
  //     var emessage = event.snapshot.value["Email"];
  //     // String car_Color = event.snapshot.value['car_color'].toString();
  //     // String car_Model = event.snapshot.value['car_model'].toString();
  //     // String car_Number = event.snapshot.value['car_number'].toString();

  //     if (event.snapshot == null) {
  //       setState(() {
  //         firstname = firstname;
  //         phone = phone;
  //         email = email;
  //         lastname = lastname;
  //         // carColor = carColor;
  //         // carModel = carModel;
  //         // carNumber = carNumber;
  //       });
  //     } else {
  //       setState(() {
  //         firstname = firstName;
  //         phone = phone;
  //         email = emessage;
  //         lastname = lastName;
  //         // carColor = car_Color;
  //         // carModel = car_Model;
  //         // carNumber = car_Number;
  //       });
  //     }
  //   });
  // }

  void createIconMarker() {
    if (animatingMarkerIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "assets/car-icon.png")
          .then((value) {
        animatingMarkerIcon = value;
      });
    }
  }

  void getRideLiveLocationUpdates() {
    LatLng oldPos = LatLng(0, 0);

    rideStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      myPosition = position;
      LatLng mPostion = LatLng(position.latitude, position.longitude);

      var rot = MapKitAssistant.getMarkerRotation(oldPos.latitude,
          oldPos.longitude, myPosition.latitude, myPosition.latitude);

      Marker animatingMarker = Marker(
        markerId: MarkerId("animating"),
        position: mPostion,
        icon: animatingMarkerIcon,
        rotation: rot,
        infoWindow: InfoWindow(title: "Current Location"),
      );

      setState(() {
        CameraPosition cameraPosition =
            new CameraPosition(target: mPostion, zoom: 17);
        _newrideGoogleMapController
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        markersSet
            .removeWhere((marker) => marker.markerId.value == "animating");
        markersSet.add(animatingMarker);
      });
      oldPos = mPostion;
      updateRideDetails();

      String rideRequestId = widget.rideDetails.ride_request_id;
      Map locMap = {
        "latitude": currentPosition.latitude.toString(),
        "longitude": currentPosition.longitude.toString(),
      };
      newRequestsRef.child(rideRequestId).child("driver_location").set(locMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isMapCreated) {
      createIconMarker();
      changeMapMode();
    }
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPaddingFromBottom),
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            compassEnabled: true,
            buildingsEnabled: true,
            trafficEnabled: true,
            circles: circleSet,
            markers: markersSet,
            polylines: polyLineSet,
            onMapCreated: (GoogleMapController controller) async {
              _controllerGoogleMap.complete(controller);
              _newrideGoogleMapController = controller;
              var currentLatLng =
                  LatLng(currentPosition.latitude, currentPosition.longitude);
              var pickUpLatLng = widget.rideDetails.pickup;
              changeMapMode();
              isMapCreated = true;
              await getPlaceDirection(currentLatLng, pickUpLatLng);
              setState(() {
                mapPaddingFromBottom = 300;
                getRideLiveLocationUpdates();
              });
            },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: kthemeColor.withOpacity(0.4),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: 300.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.timer_rounded, color: Colors.white),
                          SizedBox(
                            width: 16.0,
                          ),
                          Text(
                            durationRide,
                            style: ktextTheme2,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child:
                                Icon(Icons.phone_android, color: Colors.white),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                widget.rideDetails.rider_name,
                                style: ktextTheme3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 26.0,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/pickup.png",
                            height: 26.0,
                            width: 26.0,
                          ),
                          SizedBox(
                            width: 18.0,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                widget.rideDetails.pickup_address,
                                style: ktextTheme3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/dropoff.png",
                            height: 20.0,
                            width: 20.0,
                          ),
                          SizedBox(
                            width: 18.0,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                widget.rideDetails.dropoff_address,
                                style: ktextTheme3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 26.0,
                      ),
                      CustomButton1(
                        yourConstraints:
                            BoxConstraints.expand(width: 260, height: 60),
                        whenPressed: () async {
                          if (status == "accepted") {
                            status = "arrived";
                            String rideRequestId =
                                widget.rideDetails.ride_request_id;
                            newRequestsRef
                                .child(rideRequestId)
                                .child("status")
                                .set(status);

                            setState(() {
                              btnTitle = "Start Trip";
                              btnColor = Colors.purple;
                            });

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) =>
                                  LoadingIndicator(
                                message: "Please wait...",
                              ),
                            );

                            await getPlaceDirection(widget.rideDetails.pickup,
                                widget.rideDetails.dropoff);

                            Navigator.pop(context);
                          } else if (status == "arrived") {
                            status = "onride";
                            String rideRequestId =
                                widget.rideDetails.ride_request_id;
                            newRequestsRef
                                .child(rideRequestId)
                                .child("status")
                                .set(status);

                            setState(() {
                              btnTitle = "End Trip";
                              btnColor = kthemeColor;
                            });

                            initTimer();
                          } else if (status == "onride") {
                            endTheTrip();
                          }
                        },
                        colorChoice: btnColor,
                        widgetChoice: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              btnTitle,
                              style: ktextTheme7,
                            ),
                            Icon(
                              Icons.directions_car,
                              color: Colors.white,
                              size: 40.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Future<void> getPlaceDirection(
      LatLng pickUpLatLng, LatLng dropOffLatLng) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => LoadingIndicator(
              message: "Please wait...",
            ));

    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);

    Navigator.pop(context);

    print("This is Encoded Points ::");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);

    polylineCorOrdinates.clear();

    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        polylineCorOrdinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.purple,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polylineCorOrdinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLineSet.add(polyline);
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

    _newrideGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: kthemeColor,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickUpId"),
    );

    Circle dropOffLocCircle = Circle(
      fillColor: Colors.green,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      circleSet.add(pickUpLocCircle);
      circleSet.add(dropOffLocCircle);
    });
  }

  void acceptRideRequest() {
    String rideRequestId = widget.rideDetails.ride_request_id;
    newRequestsRef.child(rideRequestId).child("status").set("accepted");
    newRequestsRef.child(rideRequestId).child("driver_name").set('Kofi Junior');
    newRequestsRef
        .child(rideRequestId)
        .child("driver_phone")
        .set('208-4038352');
    newRequestsRef.child(rideRequestId).child("driver_id").set(dRiverID);
    newRequestsRef
        .child(rideRequestId)
        .child("car_details")
        .set('White-Tesla Model X, 4564VA');

    Map locMap = {
      "latitude": currentPosition.latitude.toString(),
      "longitude": currentPosition.longitude.toString(),
    };
    newRequestsRef.child(rideRequestId).child("driver_location").set(locMap);

    driversRef
        .child(currentfirebaseUser == null ? '' : currentfirebaseUser.uid)
        .child("history")
        .child(rideRequestId)
        .set(true);
  }

  void updateRideDetails() async {
    if (isRequestingDirection == false) {
      isRequestingDirection = true;

      if (myPosition == null) {
        return;
      }
      var posLatLng = LatLng(myPosition.latitude, myPosition.longitude);
      LatLng destinationLatLng;

      if (status == "accepted") {
        destinationLatLng = widget.rideDetails.pickup;
      } else {
        destinationLatLng = widget.rideDetails.dropoff;
      }

      var directionDetails = await AssistantMethods.obtainPlaceDirectionDetails(
          posLatLng, destinationLatLng);
      if (directionDetails != null) {
        setState(() {
          durationRide = directionDetails.durationText;
        });
      }

      isRequestingDirection = false;
    }
  }

  void initTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter = durationCounter + 1;
    });
  }

  endTheTrip() async {
    timer.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingIndicator(
        message: "Please wait...",
      ),
    );

    var currentLatLng = LatLng(myPosition.latitude, myPosition.longitude);

    var directionalDetails = await AssistantMethods.obtainPlaceDirectionDetails(
        widget.rideDetails.pickup, currentLatLng);

    Navigator.pop(context);

    int fareAmount = AssistantMethods.calculateFares(directionalDetails);

    String rideRequestId = widget.rideDetails.ride_request_id;
    newRequestsRef
        .child(rideRequestId)
        .child("fares")
        .set(fareAmount.toString());
    newRequestsRef.child(rideRequestId).child("status").set("ended");
    rideStreamSubscription.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CollectFareDialog(
        paymentMethod: widget.rideDetails.payment_method,
        fareAmount: fareAmount,
      ),
    );
    saveEarnings(fareAmount);
  }

  void saveEarnings(int fareAmount) {
    driversRef
        .child(currentfirebaseUser != null ? currentfirebaseUser.uid : '')
        .child("earnings")
        .once()
        .then((DataSnapshot dataSnapShot) {
      if (dataSnapShot.value != null) {
        double oldEarnings = double.parse(dataSnapShot.value.toString());
        double totalEarnings = fareAmount + oldEarnings;

        driversRef
            .child(currentfirebaseUser != null ? currentfirebaseUser.uid : '')
            .child("earnings")
            .set(totalEarnings.toStringAsFixed(2));
      } else {
        double totalEarnings = fareAmount.toDouble();
        driversRef
            .child(currentfirebaseUser != null ? currentfirebaseUser.uid : '')
            .child("earnings")
            .set(totalEarnings.toStringAsFixed(2));
      }
    });
  }
}
