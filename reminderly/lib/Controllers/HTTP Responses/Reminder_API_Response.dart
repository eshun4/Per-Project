import 'dart:async';
import 'dart:convert';
import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import "package:http/http.dart" as http;
import 'package:reminderly/Constants/URL_constants.dart';
import 'package:reminderly/Controllers/Exceptions/Exceptions.dart';

import 'User_API_Response.dart';

class ReminderClient {
  static const int TIME_OUT_DURATION = 20;
// Create Reminder
  Future<dynamic> createReminder(String todo, date, time, specialNotes) async {
    var uri = Uri.parse(remindersURL);
    try {
      String token = await getToken();
      var response = await http.post(uri, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      }, body: {
        'todo': todo,
        'date': date,
        'time': time,
        'special_notes': specialNotes,
      }).timeout(Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  /// ******* Send reminder **********/
  Future<dynamic> sendReminder(
      int userId, int sessionId, String todo, date, time, specialNotes) async {
    var uri = Uri.parse("$sendReminderUrl/$sessionId/$userId");
    try {
      String token = await getToken();
      var response = await http.post(uri, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      }, body: {
        'todo': todo,
        'date': date,
        'time': time,
        'special_notes': specialNotes,
      }).timeout(Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  /// ******* Get Reminders  **********/
  Future<dynamic> getReminders() async {
    var uri = Uri.parse(remindersURL);
    try {
      String token = await getToken();
      var response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ).timeout(Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  /// ******* Get Shared Reminders  **********/
  Future<dynamic> getSharedReminders(int sessionId) async {
    var uri = Uri.parse("$getsharedReminders/$sessionId");
    try {
      String token = await getToken();
      var response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ).timeout(Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  //Get Reminder Details
  Future<dynamic> editReminder(
      int reminderId, String todo, date, time, specialNotes) async {
    var uri = Uri.parse('$remindersURL/$reminderId');
    try {
      String token = await getToken();
      var response = await http.put(uri, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      }, body: {
        'todo': todo,
        'date': date,
        'time': time,
        'special_notes': specialNotes
      }).timeout(Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  //Delete Reminder
  Future<dynamic> deleteReminder(int reminderId) async {
    var uri = Uri.parse('$remindersURL/$reminderId');
    try {
      String token = await getToken();
      var response = await http.delete(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ).timeout(Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = utf8.decode(response.bodyBytes);
        var resp = JsonDecoder().convert(responseJson) as Map<String, dynamic>;
        return resp;

      case 201:
        var responseJson = utf8.decode(response.bodyBytes);
        var resp = JsonDecoder().convert(responseJson) as Map<String, dynamic>;
        return resp;

      case 400:
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request.url.toString());
      case 401:
      case 403:
        throw UnAuthorizedException(
            utf8.decode(response.bodyBytes), response.request.url.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured with code : ${response.statusCode}',
            response.request.url.toString());
    }
  }
}
