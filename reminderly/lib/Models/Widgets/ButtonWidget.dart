import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Models/MenuInfo.dart';

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
        onPressed: whenPressed as void Function(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 10,
        fillColor: colorChoice,
        padding: EdgeInsets.all(4),
        visualDensity: VisualDensity.standard,
        child: widgetChoice);
  }

  Widget buldMenuButton({MenuInfo currentMenuInfo}) {
    return Consumer<MenuInfo>(
        // ignore: missing_return
        builder: (BuildContext context, MenuInfo value, Widget child) {
      return GestureDetector(
        onTap: () {
          var menuInfo = Provider.of<MenuInfo>(context, listen: false);
          menuInfo.updateMenu(currentMenuInfo);
        },
        child: Container(
          height: 80,
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              currentMenuInfo.icon,
              Text(
                currentMenuInfo.title ?? '',
                style: kFlatButtonSmaller,
              )
            ],
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: kIndigo,
                  spreadRadius: 5,
                  blurRadius: 10.0,
                  offset: Offset(3, 0))
            ],
            border: Border(
              bottom: BorderSide(color: kIndigo),
              top: BorderSide(color: kIndigo),
              left: BorderSide(color: kIndigo),
              right: BorderSide(color: kIndigo),
            ),
            color: currentMenuInfo.menuType == value.menuType
                ? kMaroon
                : Colors.transparent,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
      );
    });
  }
}

class SignOutButton extends StatelessWidget {
  const SignOutButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).pop();
      },
      child: Container(
        height: 80,
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(FontAwesomeIcons.signOutAlt, size: 35, color: kBLue),
            Text(
              'Sign Out',
              style: kFlatButtonSmaller,
            )
          ],
        ),
        decoration: BoxDecoration(
          color: kIndigo,
          boxShadow: [
            BoxShadow(
                color: kMaroon,
                spreadRadius: 5,
                blurRadius: 10.0,
                offset: Offset(3, 10))
          ],
          border: Border(
            bottom: BorderSide(color: kIndigo),
            top: BorderSide(color: kIndigo),
            left: BorderSide(color: kIndigo),
            right: BorderSide(color: kIndigo),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types

