import 'package:flutter/material.dart';
import 'package:rideboard/Assistants/assistantmethods.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:rideboard/ui/components/custom_button.dart';

class CollectFareDialog extends StatelessWidget {
  final String paymentMethod;
  final int fareAmount;

  CollectFareDialog({this.paymentMethod, this.fareAmount});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: kthemeColor.withOpacity(0.7),
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 22.0,
            ),
            Text(
              "Trip Fare",
              style: TextStyle(fontSize: 16.0, fontFamily: "Brand Bold"),
            ),
            SizedBox(
              height: 22.0,
            ),
            Divider(
              thickness: 4.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "\$$fareAmount",
              style: ktextTheme2,
            ),
            SizedBox(
              height: 16.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "This is the total trip amount, it has been charged to the rider.",
              textAlign: TextAlign.center,
              style: ktextTheme2,
            ),
            SizedBox(
              height: 30.0,
            ),
            CustomButton1(
              yourConstraints: BoxConstraints.expand(height: 60, width: 180),
              whenPressed: () async {
                Navigator.pop(context);
                Navigator.pop(context);

                AssistantMethods.enableHomeTabLiveLocationUpdates();
              },
              colorChoice: Colors.purple,
              widgetChoice: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Collect Cash",
                    style: ktextTheme3,
                  ),
                  Icon(
                    Icons.attach_money,
                    color: Colors.white,
                    size: 26.0,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
