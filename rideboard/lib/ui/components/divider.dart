import 'package:flutter/material.dart';
import 'package:rideboard/ui/components/constants.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: kthemeColor.withOpacity(0.3),
      thickness: 1.0,
    );
  }
}
