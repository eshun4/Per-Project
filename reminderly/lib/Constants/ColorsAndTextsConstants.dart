// Theme Color
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// ************ App Colors*****************/
ThemeData kThemeData = ThemeData(
    highlightColor: kBLue,
    backgroundColor: kMaroon,
    timePickerTheme: TimePickerThemeData(
      dialHandColor: kMaroon,
      dialTextColor: Colors.white,
      entryModeIconColor: kBLue,
      helpTextStyle: kSmallTextBlue,
      dayPeriodTextColor: kBLue,
      hourMinuteTextColor: kBLue,
      dialBackgroundColor: kIndigo,
      backgroundColor: kMaroon,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: kIndigo,
            width: 5,
          )),
      hourMinuteShape: CircleBorder(),
    ),
    brightness: Brightness.light,
    primaryColor: kMaroon,
    accentColor: kIndigo,
    canvasColor: kMaroon,
    dialogTheme: DialogTheme(
        backgroundColor: kMaroon,
        titleTextStyle: kLargeText,
        contentTextStyle: kSmallText));

/// ************ App Colors*****************/
const kBLue = Color(0xFF408EC6);
const kMaroon = Color(0xFF7A2048);
const kIndigo = Color(0xFF1E2761);

/// ************ TextField Styles *****************/
const TextStyle kTextfield = TextStyle(
    fontFamily: 'Helvetica', color: Colors.white, fontStyle: FontStyle.italic);

const TextStyle kFlatButton = TextStyle(
  fontFamily: 'Helvetica',
  color: Colors.white,
  fontSize: 20,
);

const TextStyle kFlatButtonBold = TextStyle(
  fontFamily: 'Helvetica',
  color: Colors.white,
  fontSize: 25,
);

const TextStyle kFlatButtonSmaller = TextStyle(
  fontFamily: 'Helvetica',
  color: kBLue,
  fontSize: 14,
);

const TextStyle kLargeText = TextStyle(
  fontFamily: 'Helvetica',
  color: Colors.white,
  fontSize: 26,
);

const TextStyle kButton = TextStyle(
  fontFamily: 'Helvetica',
  color: Colors.white,
  fontSize: 35,
);

const TextStyle kSmallText = TextStyle(
  fontFamily: 'Helvetica',
  color: Colors.white,
  fontSize: 14,
);

const TextStyle kSmallTextBlue = TextStyle(
  fontFamily: 'Helvetica',
  color: kBLue,
  fontSize: 14,
);

const TextStyle kNoReminder = TextStyle(
    fontFamily: 'Helvetica',
    color: kMaroon,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    textBaseline: TextBaseline.alphabetic);

const TextStyle kReminders = TextStyle(
    fontFamily: 'Helvetica',
    color: kBLue,
    fontSize: 30,
    fontWeight: FontWeight.bold);

const TextStyle kAddButton = TextStyle(
    fontFamily: 'Helvetica',
    color: kBLue,
    fontSize: 45,
    fontWeight: FontWeight.bold);

const TextStyle kSlidable = TextStyle(
  fontFamily: 'Helvetica',
  color: Colors.white,
  fontSize: 20,
);

const TextStyle kReminders2 = TextStyle(
  fontFamily: 'Helvetica',
  color: kBLue,
  fontSize: 25,
);

const TextStyle kReminders3 = TextStyle(
    fontFamily: 'Helvetica',
    color: kBLue,
    fontSize: 28,
    fontWeight: FontWeight.bold);

const TextStyle kpopup = TextStyle(
  fontFamily: 'Helvetica',
  color: kBLue,
  fontSize: 40,
);

/// ************ Color Gradients *****************/
List<Color> khomeScreenLogoutGradient = [
  kMaroon,
  kMaroon,
  kIndigo,
  kMaroon,
  kMaroon,
  kIndigo,
  kMaroon,
  kMaroon,
];
