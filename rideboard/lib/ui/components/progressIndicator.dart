import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'constants.dart';

// ignore: must_be_immutable
class LoadingIndicator extends StatelessWidget {
  String message;

  LoadingIndicator({this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          width: double.infinity,
          height: double.infinity,
          color: kthemeColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message, style: kProgressIndicator),
              SizedBox(height: 40),
              SpinKitWave(
                size: 40,
                itemBuilder: (context, index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven ? Color(0xFF0A1768) : Colors.blue,
                    ),
                  );
                },
              ),
            ],
          )),
    );
  }
}
