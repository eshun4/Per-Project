import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rideboard/main.dart';
import 'package:rideboard/ui/components/Configmaps.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:rideboard/ui/components/custom_button.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class UserRatingScreen extends StatefulWidget {
  final String driverId;

  UserRatingScreen({this.driverId});

  @override
  _UserRatingScreenState createState() => _UserRatingScreenState();
}

class _UserRatingScreenState extends State<UserRatingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kthemeColor,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.all(5.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 22.0,
              ),
              Text(
                "Rate this Driver",
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
                height: 16.0,
              ),
              SmoothStarRating(
                rating: starCounter,
                color: Colors.purple,
                allowHalfRating: false,
                starCount: 5,
                size: 45,
                onRated: (value) {
                  starCounter = value;

                  if (starCounter == 1) {
                    setState(() {
                      title = "Very Bad";
                    });
                  }
                  if (starCounter == 2) {
                    setState(() {
                      title = "Bad";
                    });
                  }
                  if (starCounter == 3) {
                    setState(() {
                      title = "Good";
                    });
                  }
                  if (starCounter == 4) {
                    setState(() {
                      title = "Very Good";
                    });
                  }
                  if (starCounter == 5) {
                    setState(() {
                      title = "Excellent";
                    });
                  }
                },
              ),
              SizedBox(
                height: 14.0,
              ),
              Text(title, style: ktextTheme3),
              SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomButton1(
                  yourConstraints:
                      BoxConstraints.expand(height: 60, width: 160),
                  whenPressed: () async {
                    DatabaseReference driverRatingRef = driversRef
                        .reference()
                        .child(widget.driverId)
                        .child("ratings");

                    driverRatingRef.once().then((DataSnapshot snap) {
                      if (snap.value != null) {
                        double oldRatings = double.parse(snap.value.toString());
                        double addRatings = oldRatings + starCounter;
                        double averageRatings = addRatings / 2;
                        driverRatingRef.set(averageRatings.toString());
                      } else {
                        driverRatingRef.set(starCounter.toString());
                      }
                    });

                    Navigator.pop(context);
                  },
                  colorChoice: Colors.purple.withOpacity(0.7),
                  widgetChoice: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Submit", style: ktextTheme3),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
