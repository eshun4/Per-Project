import 'package:flutter/material.dart';

//Adjust box contraints to fit in all the contents of the button
class CustomButton1 extends StatelessWidget {
  final Function whenPressed;
  final Widget widgetChoice;
  final Color colorChoice;
  final BoxConstraints yourConstraints;

  CustomButton1(
      {this.whenPressed,
      this.widgetChoice,
      this.colorChoice,
      this.yourConstraints});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        constraints: yourConstraints,
        onPressed: whenPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 10,
        fillColor: colorChoice,
        padding: EdgeInsets.all(4),
        visualDensity: VisualDensity.standard,
        child: widgetChoice);
  }
}

class CustomFlatButton1 extends StatelessWidget {
  final Function whenPressed;
  final Widget widgetChoice;
  final Color colorChoice;
  final BoxConstraints yourConstraints;
  final TextStyle styleText;

  CustomFlatButton1(
      {this.whenPressed,
      this.widgetChoice,
      this.colorChoice,
      this.yourConstraints,
      this.styleText});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        onPressed: whenPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        constraints: yourConstraints,
        child: widgetChoice,
        disabledElevation: 0,
        textStyle: styleText);
  }
}
