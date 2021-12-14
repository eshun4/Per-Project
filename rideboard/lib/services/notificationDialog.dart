import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rideboard/Assistants/assistantmethods.dart';
import 'package:rideboard/main.dart';
import 'package:rideboard/models/rideDetails.dart';
import 'package:rideboard/ui/Screens/Driver%20Screens/Car_InfoScreen.dart';
import 'package:rideboard/ui/Screens/Driver%20Screens/newRideScreen.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:rideboard/ui/components/custom_button.dart';

class NotificationDialog extends StatelessWidget {
  final RideDetails rideDetails;

  NotificationDialog({this.rideDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: kthemeColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.0),
            Image.asset(
              "assets/car.png",
              width: 150.0,
            ),
            SizedBox(
              height: 0.0,
            ),
            Text("New Ride Request", style: ktextTheme2),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/pickup.png",
                        height: 35.0,
                        width: 35.0,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: Container(
                            child: Text(
                          rideDetails.pickup_address,
                          style: ktextTheme2,
                        )),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/dropoff.png",
                        height: 35.0,
                        width: 35.0,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                          child: Container(
                              child: Text(
                        rideDetails.dropoff_address,
                        style: ktextTheme2,
                      ))),
                    ],
                  ),
                  SizedBox(height: 0.0),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Divider(
              height: 2.0,
              thickness: 4.0,
            ),
            SizedBox(height: 0.0),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton1(
                    whenPressed: () {
                      // assetsAudioPlayer.stop();
                      Navigator.pop(context);
                    },
                    widgetChoice:
                        Text("Cancel".toUpperCase(), style: ktextTheme3),
                    colorChoice: kthemeColor,
                    yourConstraints:
                        BoxConstraints.expand(width: 100, height: 60),
                  ),
                  SizedBox(width: 15.0),
                  CustomButton1(
                    widgetChoice:
                        Text("Accept".toUpperCase(), style: ktextTheme3),
                    colorChoice: Colors.purple,
                    yourConstraints:
                        BoxConstraints.expand(width: 100, height: 60),
                    whenPressed: () {
                      checkAvailabilityOfRide(context);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.0),
          ],
        ),
      ),
    );
  }

  void checkAvailabilityOfRide(context) {
    rideRequestsRef.once().then((DataSnapshot dataSnapShot) {
      Navigator.pop(context);
      String theRideId = "";
      if (dataSnapShot.value != null) {
        theRideId = dataSnapShot.value.toString();
      } else {
        displayToastMessage("Ride not exists.", context);
      }

      if (theRideId == rideDetails.ride_request_id) {
        rideRequestsRef.set("accepted");
        AssistantMethods.disableHomeTabLiveLocationUpdates();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewRideScreen(rideDetails: rideDetails)));
      } else if (theRideId == "cancelled") {
        displayToastMessage("Ride Cancelled !", context);
      } else if (theRideId == "timeout") {
        displayToastMessage("Request timed out !", context);
      } else {
        displayToastMessage("Ride no longer exists !", context);
      }
    });
  }
}
