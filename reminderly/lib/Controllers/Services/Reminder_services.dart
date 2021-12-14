import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reminderly/Controllers/HTTP%20Responses/Reminder_API_Response.dart';
import 'package:reminderly/Controllers/Helpers/DialogsAndToasts.dart';
import 'package:reminderly/Controllers/Helpers/HelperController.dart';
import 'package:reminderly/Models/Reminder.dart';

class ReminderService extends HelperController {
  int userId = 0;

  //Create reminder
  Future<Reminder> createReminder(String todo, date, time, specialNotes) async {
    showLoading();
    var response = await ReminderClient()
        .createReminder(todo, date, time, specialNotes)
        .catchError(handleError);
    if (response == null) return response;
    hideLoading();
    DialogsAndToasts.showSnackBar(
        message: response["message"],
        title: response["status"],
        icon: Icon(Icons.email_outlined, color: Colors.white));
    Reminder responseJson = Reminder.fromJson(response);
    print(responseJson);
    return responseJson;
  }

  /// ******* Send Reminder**********/
  void sendRem(
    int userId,
    int sessionID,
    String todo,
    specialNotes,
    date,
    time,
  ) async {
    var response = await ReminderClient()
        .sendReminder(
          userId,
          sessionID,
          todo,
          specialNotes,
          date,
          time,
        )
        .catchError(handleError);
    if (response == null) return;
    // print(response);
    DialogsAndToasts.showSnackBar(
        message: response["message"],
        title: response["status"],
        icon: Icon(
          FontAwesomeIcons.bell,
          color: Colors.white,
        ));
  }

// Edit reminder
  Future<Reminder> editReminder(
      int reminderId, String todo, date, time, specialNotes) async {
    showLoading();
    var response = await ReminderClient()
        .editReminder(reminderId, todo, date, time, specialNotes)
        .catchError(handleError);
    if (response == null) return response;
    hideLoading();
    DialogsAndToasts.showSnackBar(
        message: response["message"],
        title: response["status"],
        icon: Icon(Icons.email_outlined, color: Colors.white));
    Reminder responseJson = Reminder.fromJson(response);
    print(responseJson);
    return responseJson;
  }

// Delete
  Future<Reminder> deleteReminder(int reminderId) async {
    showLoading();
    var response = await ReminderClient()
        .deleteReminder(reminderId)
        .catchError(handleError);
    if (response == null) return response;
    hideLoading();
    DialogsAndToasts.showSnackBar(
        message: response["message"],
        title: response["status"],
        icon: Icon(Icons.email_outlined, color: Colors.white));
    Reminder responseJson = Reminder.fromJson(response);
    print(responseJson);
    return responseJson;
  }
}
