import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Controllers/HTTP%20Responses/Reminder_API_Response.dart';
import 'package:reminderly/Controllers/Helpers/HelperController.dart';
import 'package:reminderly/Models/User.dart';
import 'package:reminderly/Models/Widgets/SendReminderBottomWidget.dart';

// ignore: must_be_immutable
class SharedReminderHistory extends StatefulWidget {
  User user;
  SharedReminderHistory({
    this.user,
  });

  @override
  _SharedReminderHistoryState createState() => _SharedReminderHistoryState();
}

class _SharedReminderHistoryState extends State<SharedReminderHistory>
    with HelperController {
  /// ******* Get Shared Reminder**********/
  Future<void> getShared(int sessionID) async {
    var response = await ReminderClient()
        .getSharedReminders(sessionID)
        .catchError(handleError);
    if (response == null) return;
    print(response);
    // print(responseJson);
    // return responseJson;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kMaroon,
            kBLue,
            kMaroon,
            kIndigo,
            kMaroon,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(color: kIndigo, width: 3),
              borderRadius: BorderRadius.circular(8),
              color: kMaroon,
              gradient: LinearGradient(
                colors: [
                  kIndigo,
                  kMaroon,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  child: widget.user.image == null
                      ? Icon(Icons.person, size: 50, color: kBLue)
                      : Image.network('${widget.user.image}'),
                ),
                SizedBox(width: 10),
                Text(
                  '${widget.user.firstname}' + ' ' + '${widget.user.lastname}',
                  style: kLargeText,
                ),
                SizedBox(width: 10),
                widget.user.emailVerifiedAt == null
                    ? Icon(FontAwesomeIcons.questionCircle,
                        size: 30, color: kBLue)
                    : Icon(Icons.verified_rounded, size: 30, color: kBLue)
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ignore: deprecated_member_use
                    RaisedButton(
                      onPressed: () {
                        _openSendReminderBottomSheet(userChosen: widget.user);
                        // _usercontroller.sendRem(widget.user.id ?? 0,
                        //     widget.user.session.session.id ?? 0);
                      },
                      child: Text(
                        'Send',
                        style: kFlatButtonSmaller,
                      ),
                      color: kMaroon,
                    ),
                    // ignore: deprecated_member_use
                    RaisedButton(
                      onPressed: () {
                        getShared(widget.user.session.session.id ?? 0);
                      },
                      child: Text(
                        'View Notifications',
                        style: kSmallText,
                      ),
                      color: kBLue,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _openSendReminderBottomSheet({User userChosen}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        // enableDrag: true,
        isDismissible: true,
        elevation: 5,
        backgroundColor: Colors.transparent,
        // isScrollControlled: true,
        context: context,
        builder: (context) {
          return bottomPopUpSheet(context, user: userChosen);
        });
  }

  Widget bottomPopUpSheet(BuildContext context, {User user}) {
    return SendReminderBottomWidget(
      user: user,
    );
  }
}
