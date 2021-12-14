import 'package:GamerzHub/main.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Expanded(
              child: Row(
            children: [
              Expanded(
                child: ReuseableCard(),
              )
            ],
          )),
        ],
      )),
    );
  }
}

class ReuseableCard extends StatelessWidget {
  const ReuseableCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: containerColor, borderRadius: BorderRadius.circular(15)),
    );
  }
}
