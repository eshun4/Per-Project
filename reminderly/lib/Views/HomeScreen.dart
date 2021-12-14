import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Models/MenuInfo.dart';
import 'package:reminderly/Models/Widgets/ButtonWidget.dart';
import 'package:reminderly/Models/Widgets/CustomProgressIndicator.dart';
import 'package:reminderly/Models/Widgets/enums.dart';
import 'package:reminderly/Models/navbarlist.dart';
import 'package:reminderly/Views/SideBarView/SearchContactsScreen.dart';
import 'package:reminderly/Views/SideBarView/ProfileScreen.dart';
import 'package:reminderly/Views/SideBarView/RemindersScreen.dart';
import 'package:reminderly/Views/SideBarView/SharedScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final CustomButton1 _controller = new CustomButton1();

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MenuInfo>(
        create: (context) => MenuInfo(MenuType.reminders),
        child: SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        kMaroon,
                        kBLue,
                        kMaroon,
                        kIndigo,
                        kMaroon,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Consumer<MenuInfo>(
                          builder: (BuildContext context, MenuInfo value,
                              Widget child) {
                            if (value.menuType == MenuType.reminders)
                              return RemindersScreen();
                            else if (value.menuType == MenuType.shared)
                              return SharedScreen();
                            else if (value.menuType == MenuType.contacts)
                              return SearchContactsScreen();
                            else if (value.menuType == MenuType.profile)
                              return ProfileScreen();
                            else
                              return Center(child: CustomProgressIndicator());
                          },
                        ),
                      ),
                      VerticalDivider(
                        color: kMaroon,
                        thickness: 5.0,
                        width: 14,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: menuItems
                            .map((currentMenuInfo) =>
                                _controller.buldMenuButton(
                                    currentMenuInfo: currentMenuInfo))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
