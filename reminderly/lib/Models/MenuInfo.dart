import 'package:flutter/material.dart';
import 'package:reminderly/Models/Widgets/enums.dart';

class MenuInfo extends ChangeNotifier {
  MenuType menuType;
  String title;
  Icon icon;

  MenuInfo(
    this.menuType, {
    this.title,
    this.icon,
  });

  updateMenu(MenuInfo menuInfo) {
    this.menuType = menuInfo.menuType;
    this.title = menuInfo.title;
    this.icon = menuInfo.icon;

//Important
    notifyListeners();
  }
}
