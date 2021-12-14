import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Controllers/Services/Reminder_services.dart';
import 'package:reminderly/Models/Reminder.dart';
import 'package:reminderly/Models/Widgets/TextFields.dart';

class BottomSheetWidget extends StatefulWidget {
  final Reminders reminder;

  BottomSheetWidget({this.reminder});

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  String _selectedTime = 'Select Time';
  String _selectedDate = 'Select Date';
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _todoController = new TextEditingController();
  TextEditingController _notesController = new TextEditingController();
  ReminderService _reminderController = new ReminderService();

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

  Future<void> _openTimePicker(BuildContext context) async {
    final TimeOfDay time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        _selectedTime = time.format(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.reminder != null) {
      setState(() {
        _selectedTime = widget.reminder.date;
        _selectedDate = widget.reminder.time;
        _todoController.text = widget.reminder.todo;
        _notesController.text = widget.reminder.specialNotes;
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
                        if (widget.reminder == null) {
                          _reminderController.createReminder(
                              _todoController.text,
                              _selectedDate,
                              _selectedTime,
                              _notesController.text);
                        } else {
                          _reminderController.editReminder(
                              widget.reminder.id ?? 0,
                              _todoController.text,
                              _selectedDate,
                              _selectedTime,
                              _notesController.text);
                        }

                        // DialogsAndToasts.showErroDialog(
                        //     title: "Success", description: 'Successful');
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
