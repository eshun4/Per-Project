import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Controllers/Services/Reminder_services.dart';
import 'package:reminderly/Models/User.dart';
import 'package:reminderly/Models/Widgets/TextFields.dart';

// ignore: must_be_immutable
class SendReminderBottomWidget extends StatefulWidget {
  User user;
  SendReminderBottomWidget({this.user});
  @override
  _SendReminderBottomWidgetState createState() =>
      _SendReminderBottomWidgetState();
}

class _SendReminderBottomWidgetState extends State<SendReminderBottomWidget> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  ReminderService _usercontroller = new ReminderService();
  TextEditingController _todoController = new TextEditingController();
  TextEditingController _notesController = new TextEditingController();
  String _selectedTime = 'Select Time';
  String _selectedDate = 'Select Date';
  Future<void> _openTimePicker(BuildContext context) async {
    final TimeOfDay time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        _selectedTime = time.format(context);
      });
    }
  }

  Future<void> _openDatePicker(BuildContext context) async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(DateTime.now().year - 3),
        lastDate: new DateTime(DateTime.now().year + 3));
    if (date != null) {
      setState(() {
        _selectedDate = new DateFormat.yMMMd('en_US').format(date).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kMaroon, kIndigo],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            border: Border.all(width: 4, color: kIndigo)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 372,
                  child: DynamicTextField2(
                      myController: _todoController,
                      maxLines: 2,
                      myValidator: (value) {
                        if (value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                      },
                      preferredInput: TextInputType.text,
                      label: 'Enter Todo...'),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 372,
                  child: DynamicTextField2(
                      myController: _notesController,
                      maxLines: 3,
                      myValidator: (value) {
                        if (value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                      },
                      preferredInput: TextInputType.text,
                      label: 'Additional Notes / Instructions...'),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(FontAwesomeIcons.calendarDay, color: kBLue, size: 50),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          _openDatePicker(context);
                        },
                        child: Container(
                          width: 220,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(width: 2, color: kBLue)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDate,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: kReminders3,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(FontAwesomeIcons.clock, color: kBLue, size: 50),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          _openTimePicker(context);
                        },
                        child: Container(
                          width: 220,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(width: 2, color: kBLue)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _selectedTime,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: kReminders3,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)))),
                    onPressed: () {
                      if (_key.currentState.validate()) {
                        _usercontroller.sendRem(
                          widget.user.id ?? 0,
                          widget.user.session.session.id ?? 0,
                          _todoController.text,
                          _selectedDate,
                          _selectedTime,
                          _notesController.text,
                        );
                      }
                    },
                    child: Container(
                      child: Icon(
                        Icons.add,
                        size: 60,
                        color: kIndigo,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
