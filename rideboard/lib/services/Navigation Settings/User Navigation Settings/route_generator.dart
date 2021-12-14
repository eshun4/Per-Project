import 'package:flutter/material.dart';
import 'package:rideboard/main.dart';
import 'package:rideboard/services/notificationDialog.dart';
import 'package:rideboard/ui/Screens/Driver%20Screens/Car_InfoScreen.dart';
import 'package:rideboard/ui/Screens/Driver%20Screens/DriverProfileScreen.dart';
import 'package:rideboard/ui/Screens/Driver%20Screens/Driver_Screen.dart';
import 'package:rideboard/ui/Screens/Driver%20Screens/NavBarTabs/DriverprofileTab.dart';
import 'package:rideboard/ui/Screens/Driver%20Screens/NavBarTabs/ratingtabscreen.dart';
import 'package:rideboard/ui/Screens/Driver%20Screens/newRideScreen.dart';
import 'package:rideboard/ui/Screens/User%20Screens/AboutScreen.dart';
import 'package:rideboard/ui/Screens/User%20Screens/Getting_Started.dart';
import 'package:rideboard/ui/Screens/User%20Screens/Login_Screen.dart';
import 'package:rideboard/ui/Screens/User%20Screens/Rider_Screen.dart';
import 'package:rideboard/ui/Screens/User%20Screens/Search_Screen.dart';
import 'package:rideboard/ui/Screens/User%20Screens/Sign_Up.dart';
import 'package:rideboard/ui/Screens/User%20Screens/UserProfileScreen.dart';
import 'package:rideboard/ui/Screens/User%20Screens/UserRideHistory.dart';
import 'package:rideboard/ui/Screens/User%20Screens/profileImageUploadScreen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/UserRideHistory':
        return MaterialPageRoute(builder: (_) => UserRideHistory());
      case '/CarInfo':
        return MaterialPageRoute(builder: (_) => CarInfoScreen());
      case '/UserProfile':
        return MaterialPageRoute(builder: (_) => UserProfileScreen());
      case '/AboutScreen':
        return MaterialPageRoute(builder: (_) => AboutScreen());
      case '/RatingsTab':
        return MaterialPageRoute(builder: (_) => DriverRatingPage());
      case '/DriverMainProfileScreen':
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case '/DriverProfileScreen':
        return MaterialPageRoute(builder: (_) => DriverProfilePage());
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case '/GettingStarted':
        return MaterialPageRoute(builder: (_) => GettingStarted());
      case "/Rider":
        return MaterialPageRoute(builder: (_) => RiderPage());
      case "/Driver":
        return MaterialPageRoute(builder: (_) => DriverHomeScreen());
      case "/DriverCarInfo":
        return MaterialPageRoute(builder: (_) => CarInfoScreen());
      case "/Search":
        return MaterialPageRoute(builder: (_) => SearchScreen());
      case "/SplashScreen":
        return MaterialPageRoute(builder: (_) => LoadingScreen());
      case "/NewRideScreen":
        return MaterialPageRoute(builder: (_) => NewRideScreen());
      case "/ProfileImageScreen":
        return MaterialPageRoute(builder: (_) => ProfileImageUploadScreen());
    }
  }
}
