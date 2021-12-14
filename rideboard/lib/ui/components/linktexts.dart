import 'package:flutter/material.dart';
import 'constants.dart';

class PasswordLinkText extends StatelessWidget {
  final String textToDisplay;

  PasswordLinkText({this.textToDisplay});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(textToDisplay, style: kFlatbutton),
        ],
      ),
    );
  }
}

class UsernameLinktext extends StatelessWidget {
  final String textToDisplay;
  UsernameLinktext({this.textToDisplay});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Forgot Username?', style: kFlatbutton),
        ],
      ),
    );
  }
}
