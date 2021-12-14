import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:rideboard/ui/components/custom_button.dart';

class GettingStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: kthemeColor.withOpacity(0.1),
          textTheme: ktextTheme,
        ),
        home: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/Wallpaper-4.png'),
                    fit: BoxFit.cover),
              ),
            ),
            Material(
                color: kthemeColor.withOpacity(0.3),
                child: Container(
                  child: Scaffold(
                    body: SafeArea(
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 80),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                        child: Container(
                                      padding: EdgeInsets.all(30),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: kthemeColor.withOpacity(0.4)),
                                      child: Column(
                                        children: [
                                          Text('Welcome to RideBoard',
                                              style: ktextTheme2),
                                          Image.asset('assets/logo.png',
                                              scale: 4.5),
                                          SizedBox(height: 20),
                                          Text(
                                            'Hitch a Ride ASAP!',
                                            style: kSplashScreen,
                                          ),
                                          SizedBox(height: 10),
                                          CustomButton1(
                                            colorChoice:
                                                kthemeColor.withOpacity(0.9),
                                            whenPressed: () {
                                              Navigator.pushNamed(
                                                  context, "/Rider");
                                              _restartApp();
                                            },
                                            yourConstraints:
                                                BoxConstraints.expand(
                                                    height: 80, width: 190),
                                            widgetChoice: Center(
                                              child: Text(
                                                'Get Started',
                                                style: kgetStarted,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void _restartApp() async {
    FlutterRestart.restartApp();
  }
}
