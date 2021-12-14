import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Models/MenuInfo.dart';
import 'package:reminderly/Models/Widgets/enums.dart';

List<MenuInfo> menuItems = [
  MenuInfo(MenuType.reminders,
      title: 'Reminders',
      icon: Icon(
        FontAwesomeIcons.bell,
        color: kBLue,
      )),
  MenuInfo(MenuType.shared,
      title: 'Shared',
      icon: Icon(
        FontAwesomeIcons.stickyNote,
        size: 35,
        color: kBLue,
      )),
  MenuInfo(MenuType.contacts,
      title: 'Contacts',
      icon: Icon(
        FontAwesomeIcons.userFriends,
        size: 35,
        color: kBLue,
      )),
  MenuInfo(MenuType.profile,
      title: 'Profile',
      icon: Icon(
        FontAwesomeIcons.user,
        size: 35,
        color: kBLue,
      )),
];
