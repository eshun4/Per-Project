import 'package:flutter/material.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:rideboard/ui/components/custom_button.dart';

class AboutScreen extends StatefulWidget {
  @override
  _MyAboutScreenState createState() => _MyAboutScreenState();
}

class _MyAboutScreenState extends State<AboutScreen> {
  Image image1;
  AssetImage image2;
  @override
  void initState() {
    super.initState();

    image1 = Image.asset('assets/logo.png');
    image2 = AssetImage('assets/PATTERN4.png');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(image1.image, context);
    precacheImage(image2, context);
  }

  @override
  Widget build(BuildContext context) {
    image2.resolve(createLocalImageConfiguration(context));
    return Scaffold(
        backgroundColor: kthemeColor,
        body: Stack(children: [
          SafeArea(
            child: Container(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: image2, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          ListView(
            children: <Widget>[
              Container(
                height: 220,
                child: Center(
                  child: image1,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, left: 24, right: 24),
                child: Column(
                  children: [
                    Text(
                      'This app was developed by Kofi Junior Eshun, Computer Science Major and '
                      ' aspiring Web & Software Developer. This app offers cheap rides at cheap'
                      'rates to riders who would like to hitch rides from a neighbour, friends '
                      'or complete strangers, and that\'s why it is a quick and very simple way '
                      'for you to make some money, while travelling on long or short journeys.'
                      ' As you use this app you agree to all its user terms and commit to comply '
                      ' to all the Rules and Regulations that come with it. In the end we believe'
                      ' you use your own discretion to book and offer rides to any user.',
                      style: ktextTheme3,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              CustomButton1(
                yourConstraints: BoxConstraints.expand(height: 60, width: 180),
                colorChoice: Colors.purple,
                whenPressed: () {
                  Navigator.of(context).pop();
                },
                widgetChoice: Text('Go Back', style: ktextTheme8),
              ),
            ],
          ),
        ]));
  }
}
