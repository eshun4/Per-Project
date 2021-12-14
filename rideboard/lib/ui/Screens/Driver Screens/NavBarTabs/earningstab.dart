import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideboard/services/appData.dart';
import 'package:rideboard/ui/Screens/Driver%20Screens/HistoryScreen.dart';
import 'package:rideboard/ui/components/constants.dart';

class DriverEarningsTab extends StatefulWidget {
  const DriverEarningsTab({Key key}) : super(key: key);

  @override
  _DriverEarningsTabState createState() => _DriverEarningsTabState();
}

class _DriverEarningsTabState extends State<DriverEarningsTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: kthemeColor,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [
                Text(
                  'Total Earnings',
                  style: ktextTheme7,
                ),
                Text(
                  "\$${Provider.of<AppData>(context, listen: false).earnings}",
                  style: ktextTheme7,
                )
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HistoryScreen()));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            child: Row(
              children: [
                Image.asset(
                  'assets/car.png',
                  width: 70,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  'Total Trips',
                  style: ktextTheme6,
                ),
                Expanded(
                    child: Container(
                        child: Text(
                  Provider.of<AppData>(context, listen: false)
                      .countTrips
                      .toString(),
                  textAlign: TextAlign.end,
                  style: ktextTheme3,
                ))),
              ],
            ),
          ),
        ),
        Divider(
          height: 2.0,
          thickness: 2.0,
        ),
      ],
    );
  }
}
