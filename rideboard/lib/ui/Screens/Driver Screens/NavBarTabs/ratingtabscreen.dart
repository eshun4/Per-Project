import 'package:flutter/material.dart';
import 'package:rideboard/ui/components/Configmaps.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class DriverRatingPage extends StatelessWidget {
  const DriverRatingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kthemeColor,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: kthemeColor,
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
                "Your Ratings",
                style: ktextTheme6,
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
                allowHalfRating: true,
                starCount: 5,
                size: 45,
                isReadOnly: true,
              ),
              SizedBox(
                height: 14.0,
              ),
              Text(title, style: ktextTheme7),
              SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
