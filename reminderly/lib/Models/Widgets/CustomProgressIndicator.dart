import 'package:flutter/material.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';

class CustomProgressIndicator extends StatefulWidget {
  @override
  _CustomProgressIndicatorState createState() =>
      _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator>
    with TickerProviderStateMixin {
  AnimationController animation1;
  AnimationController animation2;
  AnimationController animation3;
  Animation<double> _fadeInFadeOut1;
  Animation<double> _fadeInFadeOut2;
  Animation<double> _fadeInFadeOut3;
  @override
  void initState() {
    super.initState();
    animation1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _fadeInFadeOut2 = Tween<double>(begin: 0.0, end: 1.0).animate(animation1);
    animation2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _fadeInFadeOut3 = Tween<double>(begin: 0.0, end: 1.0).animate(animation2);
    animation3 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeInFadeOut1 = Tween<double>(begin: 0.0, end: 1.0).animate(animation3);

    animation1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animation1.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animation1.forward();
      }
    });
    animation2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animation2.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animation2.forward();
      }
    });
    animation3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animation3.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animation3.forward();
      }
    });
    animation1.forward();
    animation2.forward();
    animation3.forward();
  }

  // ignore: must_call_super
  void dispose() {
    animation1.dispose();
    animation2.dispose();
    animation3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeInFadeOut1,
                child: CircleAvatar(
                  backgroundColor: kBLue,
                  radius: 25,
                ),
              ),
              SizedBox(width: 15),
              FadeTransition(
                opacity: _fadeInFadeOut2,
                child: CircleAvatar(
                  backgroundColor: kMaroon,
                  radius: 25,
                ),
              ),
              SizedBox(width: 15),
              FadeTransition(
                opacity: _fadeInFadeOut3,
                child: CircleAvatar(
                  backgroundColor: kIndigo,
                  radius: 25,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
