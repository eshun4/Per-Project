import 'package:flutter/material.dart';
import 'package:rideboard/main.dart';
import 'package:rideboard/ui/components/Configmaps.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:rideboard/ui/components/custom_button.dart';

class NoDriverAvailableDialog extends StatefulWidget {
  @override
  _NoDriverAvailableDialogState createState() =>
      _NoDriverAvailableDialogState();
}

class _NoDriverAvailableDialogState extends State<NoDriverAvailableDialog> {
  String firstname = '';
  @override
  void initState() {
    super.initState();
    _fetchusername3();
  }

  _fetchusername3() async {
    usersRef
        .child(currentfirebaseUser == null ? '' : currentfirebaseUser.uid)
        .onValue
        .listen((event) {
      var firstName = event.snapshot.value["firstname"];
      if (event.snapshot == null) {
        setState(() {
          firstname = firstname;
        });
      } else {
        setState(() {
          firstname = firstName;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: kthemeColor.withOpacity(0.7),
      child: Container(
        margin: EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: kthemeColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'No driver found',
                  style: ktextTheme3,
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Sorry $firstname there is no driver available at this time.',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomButton1(
                    whenPressed: () {
                      Navigator.pop(context);
                    },
                    colorChoice: Colors.purple,
                    widgetChoice: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Close", style: kCustomButton2),
                        Icon(
                          Icons.close_sharp,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ],
                    ),
                    yourConstraints:
                        BoxConstraints.expand(height: 60, width: 160),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
