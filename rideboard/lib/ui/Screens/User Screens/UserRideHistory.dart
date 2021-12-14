import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideboard/services/appData.dart';
import 'package:rideboard/ui/components/HistoryItem.dart';
import 'package:rideboard/ui/components/constants.dart';

class UserRideHistory extends StatefulWidget {
  UserRideHistory({Key key}) : super(key: key);

  @override
  _UserRideHistoryState createState() => _UserRideHistoryState();
}

class _UserRideHistoryState extends State<UserRideHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ride History',
          style: ktextTheme3,
        ),
        backgroundColor: kthemeColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return HistoryItem(
            history: Provider.of<AppData>(context, listen: false)
                .tripHistoryDataList[index],
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          thickness: 3.0,
          height: 3.0,
        ),
        itemCount: Provider.of<AppData>(context, listen: false)
            .tripHistoryDataList
            .length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}
