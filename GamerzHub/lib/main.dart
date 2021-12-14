import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'main_screen.dart';

main() => runApp(GamerzHub());

const Color textColor = Color(0xFff9f7f7);
const Color containerColor = Color(0xFF242424);

class GamerzHub extends StatelessWidget {
  const GamerzHub({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoadingScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFe20100),
        textTheme: TextTheme(
          body1: TextStyle(
              color: textColor, fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      backgroundColor: Color(0xFFe20100),
      image: Image.asset('assets/GamerzHub16.png'),
      loaderColor: Color(0xFF242424),
      navigateAfterSeconds: MainScreen(),
      seconds: 5,
      photoSize: 100,
    );
  }
}
