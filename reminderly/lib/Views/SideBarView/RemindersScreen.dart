import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Controllers/HTTP%20Responses/Reminder_API_Response.dart';
import 'package:reminderly/Controllers/HTTP%20Responses/User_API_Response.dart';
import 'package:reminderly/Controllers/Helpers/DialogsAndToasts.dart';
import 'package:reminderly/Controllers/Helpers/HelperController.dart';
import 'package:reminderly/Controllers/Services/Reminder_services.dart';
import 'package:reminderly/Models/Reminder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reminderly/Models/Widgets/BottomSheetWidget.dart';
import 'package:reminderly/Models/Widgets/CustomProgressIndicator.dart';

class RemindersScreen extends StatefulWidget {
  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen>
    with HelperController {
  // ignore: unused_field
  DialogsAndToasts _contrDiagandToasts = new DialogsAndToasts();
  bool _loading = true;
  int userId = 0;
  List<Reminders> rem = [];
  List<Color> gradientColor = [
    kMaroon,
    kIndigo,
  ];
  Timer timer;
  ReminderService _reminderController = new ReminderService();

  //Get Reminder
  Future<void> getReminder() async {
    userId = await getUserId();
    var response =
        await ReminderClient().getReminders().catchError(handleError);
    if (response == null) return response;
    // ignore: unnecessary_cast
    Reminder responseJson = Reminder.fromJson(response) as Reminder;
    print(response);
    if (mounted) {
      setState(() {
        rem = responseJson.reminders;
        _loading = _loading ? !_loading : _loading;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getReminder();
      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        getReminder();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: () {
            _openAddReminderBottomSheet();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 62,
                width: MediaQuery.of(context).size.width / 5.5,
                decoration: BoxDecoration(
                    border: Border.all(color: kIndigo, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColor.last.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 5,
                        offset: Offset(4, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: gradientColor,
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    )),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.plusCircle,
                      size: 50,
                      color: kBLue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        _loading
            ? Center(child: CustomProgressIndicator())
            : SizedBox(
                height: 5,
              ),
        Expanded(
          flex: 1,
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                color: kMaroon,
                backgroundColor: kBLue,
                onRefresh: getReminder,
                child: rem.isEmpty && rem.length == 0
                    ? Text(
                        'You have no reminders.',
                        style: kNoReminder,
                      )
                    : ListView(
                        children: rem.map((reminder) {
                        Reminders _reminder = reminder;
                        print(_reminder.user.firstname);
                        return Slidable(
                          actionPane: SlidableScrollActionPane(),
                          actions: [
                            IconSlideAction(
                              color: kIndigo,
                              iconWidget: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.edit,
                                    color: Colors.white,
                                    size: 65,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Edit',
                                    style: kSlidable,
                                  )
                                ],
                              ),
                              onTap: () {
                                _openAddReminderBottomSheet(rem: _reminder);
                              },
                            ),
                            IconSlideAction(
                              color: kMaroon,
                              iconWidget: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.trash,
                                    color: Colors.white,
                                    size: 65,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Delete',
                                    style: kSlidable,
                                  )
                                ],
                              ),
                              onTap: () {
                                _reminderController
                                    .deleteReminder(_reminder.id ?? 0);
                              },
                            )
                          ],
                          actionExtentRatio: 1 / 3,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: kIndigo, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          gradientColor.last.withOpacity(0.4),
                                      blurRadius: 8,
                                      spreadRadius: 5,
                                      offset: Offset(4, 4),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: LinearGradient(
                                    colors: gradientColor,
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.solidBell,
                                          color: kBLue,
                                          size: 30,
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.6,
                                            child: Text(
                                              reminder.todo.toString(),
                                              style: kReminders,
                                              maxLines: 1,
                                              textDirection: TextDirection.ltr,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.clipboardList,
                                          color: kBLue,
                                          size: 30,
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.3,
                                            child: Text(
                                              reminder.specialNotes.toString(),
                                              style: kReminders2,
                                              maxLines: 1,
                                              textDirection: TextDirection.ltr,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.calendarAlt,
                                          color: kBLue,
                                          size: 30,
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.3,
                                            child: Text(
                                              reminder.date.toString(),
                                              style: kReminders2,
                                              textDirection: TextDirection.ltr,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.clock,
                                          color: kBLue,
                                          size: 30,
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.3,
                                            child: Text(
                                              reminder.time.toString(),
                                              style: kReminders2,
                                              textDirection: TextDirection.ltr,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList())),
          ),
        ),
      ],
    );
  }

  void _openAddReminderBottomSheet({Reminders rem}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        enableDrag: true,
        // isDismissible: true,
        elevation: 5,
        backgroundColor: Colors.transparent,

        // isScrollControlled: true
        context: context,
        builder: (context) {
          return bottomPopUpSheet(context, remmy: rem);
        });
  }
}

Widget bottomPopUpSheet(BuildContext context, {Reminders remmy}) {
  return BottomSheetWidget(
    reminder: remmy,
  );
}
