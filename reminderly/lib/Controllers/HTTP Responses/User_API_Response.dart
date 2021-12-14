import 'dart:async';
import 'dart:convert';
import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:reminderly/Controllers/Exceptions/Exceptions.dart';
import 'package:reminderly/Constants/URL_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserClient {
  static const int TIME_OUT_DURATION = 20;

  /// ******* Login User **********/
  Future<dynamic> login(String email, String password) async {
    var uri = Uri.parse(loginURL);
    try {
      // String token = await getToken();
      // PusherSocket().socket(authToken: token);
      var response = await http.post(uri, headers: {
        'Accept': 'application/json'
      }, body: {
        'email': email,
        'password': password
      }).timeout(Duration(seconds: TIME_OUT_DURATION));

      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  /// ******* Logout User **********/
  Future<dynamic> signOut() async {
    var uri = Uri.parse(logoutURL);
    try {
      String token = await getToken();
      var response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ).timeout(Duration(seconds: TIME_OUT_DURATION));
      logout();
      print(token);
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  /// ******* Get Contacts **********/
  Future<dynamic> getContacts() async {
    var uri = Uri.parse(getContactsURL);
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

  /// ******* Create Session **********/
  Future<dynamic> createSession(int userId) async {
    var uri = Uri.parse("$createSessionURL/$userId");
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

  /// ******* Get Contacts **********/
  Future<dynamic> toggleContact(int userId) async {
    var uri = Uri.parse('$toggleContactURL/$userId');
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

  /// ******* Register User **********/
  Future<dynamic> register(String firstname, String lastname, String email,
      String phone, String password) async {
    var uri = Uri.parse(registerURL);
    try {
      var response = await http.post(uri, headers: {
        'Accept': 'application/json'
      }, body: {
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': password
      }).timeout(Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  /// ******* Get User Details **********/
  Future<dynamic> getUserDetails() async {
    var uri = Uri.parse(userURL);
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

  /// ******* Get All Users **********/
  Future<dynamic> getAllUsers() async {
    var uri = Uri.parse(usersURL);
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

  /// ******* Update User Details **********/
  Future<dynamic> updateUserDetails(
      String firstname, lastname, phone, image) async {
    var uri = Uri.parse(userURL);
    try {
      String token = await getToken();
      var response = await http
          .put(uri,
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: image == null
                  ? {
                      'firstname': firstname,
                      'lastname': lastname,
                      'phone': phone,
                    }
                  : {
                      'firstname': firstname,
                      'lastname': lastname,
                      'phone': phone,
                      'image': image
                    })
          .timeout(Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  /// ******* Verify User Email **********/
  Future<dynamic> verifyUserEmail() async {
    var uri = Uri.parse(emailVerification);
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

  /// ******* Send user Password reset Email **********/
  Future<dynamic> sendUserPasswordResetEmail(String email) async {
    var uri = Uri.parse(passwordResetEmail);
    try {
      var response = await http.post(uri,
          headers: {'Accept': 'application/json', 'Authorization': 'No Auth'},
          body: {'email': email}).timeout(Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  /// ******* Reset User Password **********/
  Future<dynamic> resetUserPassword(
      String email, password, passwordConfirmation, resetcode) async {
    var uri = Uri.parse(passwordReset);
    try {
      var response = await http.post(uri, headers: {
        'Accept': 'application/json',
        'Authorization': 'No Auth'
      }, body: {
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'token': resetcode
      }).timeout(Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  /// ******* Api Response Processor **********/
  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 201:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 400:
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request.url.toString());
      case 401:
        var responseJson = utf8.decode(response.bodyBytes);
        final res = jsonDecode(responseJson)['message'];
        return res;
        break;
      case 403:
        var responseJson = utf8.decode(response.bodyBytes);
        final res = jsonDecode(responseJson)['message'];
        // var err = [res.values.elementAt(0)][0][0];
        throw UnAuthorizedException(
            '${res.toString()}', response.request.url.toString());
      case 500:
        throw InternalServerError(
            utf8.decode(response.bodyBytes), response.request.url.toString());
      case 409:
      case 422:
        var responseJson = utf8.decode(response.bodyBytes);
        final res = jsonDecode(responseJson)['errors'];
        var err = [res.values.elementAt(0)][0][0];
        throw UserAlreadyExists(
            '${err.toString()}', response.request.url.toString());
      default:
        throw FetchDataException(
            'Error occured with code : ${response.statusCode}}',
            response.request.url.toString());
    }
  }

  // logout
  Future<bool> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.clear();
  }
}

// get token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// get user id
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// Get base64 encoded image
String getStringImage(File file) {
  // ignore: unnecessary_null_comparison
  if (file == null) return '';
  return base64Encode(file.readAsBytesSync());
}
