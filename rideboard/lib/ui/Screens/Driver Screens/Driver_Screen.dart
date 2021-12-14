import 'package:flutter/material.dart';
import 'package:rideboard/ui/Screens/Driver%20Screens/NavBarTabs/earningstab.dart';
import 'package:rideboard/ui/Screens/Driver%20Screens/NavBarTabs/homeTabScreen.dart';
import 'package:rideboard/ui/Screens/Driver%20Screens/NavBarTabs/DriverprofileTab.dart';
import 'package:rideboard/ui/Screens/Driver%20Screens/NavBarTabs/ratingtabscreen.dart';
import 'package:rideboard/ui/components/constants.dart';

class DriverHomeScreen extends StatefulWidget {
  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int selectedIndex = 0;

  void onItemclicked(int index) {
    selectedIndex = index;
    tabController.index = selectedIndex;
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: tabController,
            children: [
              DriverApp(),
              DriverRatingPage(),
              DriverEarningsTab(),
              DriverProfilePage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: kthemeColor.withOpacity(0.7),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.white),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star, color: Colors.white),
                label: 'Ratings',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.credit_card_rounded, color: Colors.white),
                  label: 'Earnings'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person, color: Colors.white),
                  label: 'Account')
            ],
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.purple,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: ktextTheme4,
            unselectedLabelStyle: ktextTheme4,
            showUnselectedLabels: true,
            onTap: onItemclicked,
            currentIndex: selectedIndex,
          ),
        ),
      ]),
    );
  }
}
