import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reminderly/Controllers/Exceptions/Exceptions.dart';
import 'package:reminderly/Controllers/Helpers/DialogsAndToasts.dart';

class HelperController {
  void handleError(error) {
    hideLoading();
    if (error is BadRequestException) {
      var message = error.message;
      DialogsAndToasts.showSnackBar(
          message: message,
          icon: Icon(FontAwesomeIcons.flagCheckered, color: Colors.red),
          title: "Error");
    } else if (error is FetchDataException) {
      var message = error.message;
      DialogsAndToasts.showErroDialog(description: message);
    } else if (error is ApiNotRespondingException) {
      var message = error.message;
      DialogsAndToasts.showSnackBar(
          message: message,
          icon: Icon(FontAwesomeIcons.flagCheckered, color: Colors.red),
          title: "Error");
    } else if (error is InternalServerError) {
      var message = error.message;
      DialogsAndToasts.showSnackBar(
          message: message,
          icon: Icon(FontAwesomeIcons.flagCheckered, color: Colors.red),
          title: "Error");
    } else if (error is UserAlreadyExists) {
      var message = error.message;
      DialogsAndToasts.showSnackBar(
          message: message,
          icon: Icon(FontAwesomeIcons.flagCheckered, color: Colors.red),
          title: "Error");
    } else if (error is UnAuthorizedException) {
      var message = error.message;
      DialogsAndToasts.showSnackBar(
          message: message,
          icon: Icon(FontAwesomeIcons.flagCheckered, color: Colors.red),
          title: "Error");
    } else if (error is UnAuthenticatedException) {
      var message = error.message;
      DialogsAndToasts.showErroDialog(description: message);
    }
  }

  showLoading([String message]) {
    DialogsAndToasts.showLoading(message);
  }

  hideLoading() {
    DialogsAndToasts.hideLoading();
  }
}
