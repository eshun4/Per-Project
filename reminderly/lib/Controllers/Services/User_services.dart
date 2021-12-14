import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:reminderly/Controllers/HTTP%20Responses/User_API_Response.dart';
import 'package:reminderly/Controllers/Helpers/DialogsAndToasts.dart';
import 'package:reminderly/Controllers/Helpers/HelperController.dart';
import 'package:reminderly/Models/User.dart';
import 'package:reminderly/Views/HomeScreen.dart';
import 'package:reminderly/Views/VerificationPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices extends GetxController with HelperController {
  /// ******* Register User **********/
  void registerUser(
      String firstname, lastname, email, phone, String password) async {
    showLoading('Loading');
    var response = await UserClient()
        .register(firstname, lastname, email, phone, password)
        .catchError(handleError);
    if (response == null) return;
    var res = jsonDecode(response);
    hideLoading();
    var responseBody = UserObject.fromJson(res);
    // ignore: unnecessary_cast
    _saveAndRedirectToVerify(responseBody as UserObject);
  }

  /// ******* Login User **********/
  void loginUser(String email, password) async {
    showLoading();
    var response =
        await UserClient().login(email, password).catchError(handleError);
    if (response == null) return;
    var res = jsonDecode(response);
    hideLoading();
    var responseBody = UserObject.fromJson(res);
    // ignore: unnecessary_cast
    _saveAndRedirectToHomeScreen(responseBody as UserObject);
    print(responseBody);
    print(response);
  }

  /// ******* Toggle Contact **********/
  void toggleContact(int userId) async {
    var response =
        await UserClient().toggleContact(userId).catchError(handleError);
    if (response == null) return;
    var res = jsonDecode(response);
    print(res);
    DialogsAndToasts.showSnackBar(
        message: res["message"],
        title: res["status"],
        icon: Icon(
          FontAwesomeIcons.bell,
          color: Colors.white,
        ));
  }

  /// ******* Update User Details **********/
  void updateUserDetails(String firstname, lastname, phone, image) async {
    showLoading();
    var response = await UserClient()
        .updateUserDetails(firstname, lastname, phone, image)
        .catchError(handleError);
    if (response == null) return response;
    hideLoading();
    var res = JsonDecoder().convert(response) as Map<String, dynamic>;
    // ignore: unnecessary_cast
    // ignore: unused_local_variable
    var responseJson =
        // ignore: unnecessary_cast
        User.fromJson(res['users']) as User;
    // ignore: unnecessary_cast
    print(res['users']);
    print(response);
  }

  /// ******* Verify User **********/
  void verifyUser() async {
    // showLoading();
    var response = await UserClient().verifyUserEmail().catchError(handleError);
    if (response == null) return;
    var res = jsonDecode(response);
    // ignore: unnecessary_cast
    DialogsAndToasts.showSnackBar(
        message: res["message"],
        title: res["status"],
        icon: Icon(
          FontAwesomeIcons.bell,
          color: Colors.white,
        ));
    print(response);
  }

  /// ******* Send Forgot Password Email **********/
  void sendUserPasswordForgotEmail(String email) async {
    // showLoading();
    var response = await UserClient()
        .sendUserPasswordResetEmail(email)
        .catchError(handleError);
    if (response == null) return;
    var res = jsonDecode(response);
    // ignore: unnecessary_cast
    DialogsAndToasts.showSnackBar(
        message: res["message"],
        title: res["status"],
        icon: Icon(
          FontAwesomeIcons.bell,
          color: Colors.white,
        ));
    print(res);
  }

  /// ******* Reset user Password **********/
  void resetUserPassword(
      String email, password, passwordConfirmation, code) async {
    // showLoading();
    var response = await UserClient()
        .resetUserPassword(email, password, passwordConfirmation, code)
        .catchError(handleError);
    if (response == null) return;
    var res = jsonDecode(response);
    // ignore: unnecessary_cast
    DialogsAndToasts.showSnackBar(
        message: res["message"],
        title: res["status"],
        icon: Icon(
          FontAwesomeIcons.bell,
          color: Colors.white,
        ));
    print(res);
  }

  /// ******* Save and redirect User Function **********/
  void _saveAndRedirectToVerify(UserObject user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.user.id ?? 0);
    Get.to(() => VerifyUser(user: user.user));
  }

  /// ******* Save and redirect User Function **********/
  void _saveAndRedirectToHomeScreen(UserObject user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.user.id ?? 0);
    Get.to(() => HomeScreen());
    print(user.user.firstname);
  }

  /// ******* Logout **********/
  void logoutUser() async {
    showLoading();
    var response = await UserClient().signOut().catchError(handleError);
    if (response == null) return;
    var res = jsonDecode(response);
    hideLoading();
    print(res);
    var logout = UserClient().logout();
    print(logout);
  }
}
