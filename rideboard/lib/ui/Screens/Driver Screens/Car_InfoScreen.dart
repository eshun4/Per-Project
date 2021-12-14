import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rideboard/main.dart';
import 'package:rideboard/ui/components/Configmaps.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:rideboard/ui/components/custom_button.dart';
import 'package:rideboard/ui/components/progressIndicator.dart';
import 'package:rideboard/ui/components/text_field.dart';

class CarInfoScreen extends StatefulWidget {
  @override
  _CarInfoScreenState createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModelTextEditingController = TextEditingController();

  TextEditingController carNumberTextEditingController =
      TextEditingController();

  TextEditingController carColorTextEditingController = TextEditingController();
  Image image1;
  AssetImage image2;
  @override
  void initState() {
    super.initState();
    image1 = Image.asset(
      'assets/logo.png',
      gaplessPlayback: true,
      scale: 4.5,
    );
    image2 = AssetImage('assets/Wallpaper-2.png');
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
    return Container(
      child: Container(
        color: kthemeColor,
        height: double.infinity,
        width: double.infinity,
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(image: image2, fit: BoxFit.cover),
          ),
          child: SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 22.0,
                    ),
                    Image.asset(
                      "assets/logo.png",
                      width: 390.0,
                      height: 250.0,
                      scale: 4.5,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 12.0,
                              ),
                              Text(
                                "Enter Car Details",
                                style: ktextTheme3,
                              ),
                              SizedBox(
                                height: 26.0,
                              ),
                              DynamicTextField(
                                label: "Car Model",
                                myController: carModelTextEditingController,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              DynamicTextField(
                                myController: carNumberTextEditingController,
                                label: "Car Number",
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              DynamicTextField(
                                label: "Car Color",
                                myController: carColorTextEditingController,
                              ),
                              SizedBox(
                                height: 26.0,
                              ),
                              // DropdownButton(
                              //   iconSize: 40,
                              //   hint: Text('Please choose Car Type'),
                              //   value: selectedCarType,
                              //   onChanged: (newValue) {
                              //     // setState(() {
                              //     //   selectedCarType = newValue;
                              //     //   displayToastMessage(selectedCarType, context);
                              //     // });
                              //   },
                              //   items: carTypesList.map((car) {
                              //     return DropdownMenuItem(
                              //       child: new Text(car),
                              //       value: car,
                              //     );
                              //   }).toList(),
                              // ),
                              SizedBox(
                                height: 42.0,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: CustomButton1(
                                  yourConstraints: BoxConstraints.expand(
                                      height: 60, width: 290),
                                  colorChoice: kthemeColor.withOpacity(0.8),
                                  whenPressed: () {
                                    if (carModelTextEditingController
                                        .text.isEmpty) {
                                      displayToastMessage(
                                          "Please Enter Car Model.", context);
                                    } else if (carNumberTextEditingController
                                        .text.isEmpty) {
                                      displayToastMessage(
                                          "Please Enter Car Number.", context);
                                    } else if (carColorTextEditingController
                                        .text.isEmpty) {
                                      displayToastMessage(
                                          "Please Enter Car Color.", context);
                                    } else {
                                      saveDriverCarInfo(context);
                                    }
                                  },
                                  widgetChoice: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Next",
                                        style: kCustomButton2,
                                      ),
                                      SizedBox(width: 6),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 35.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveDriverCarInfo(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingIndicator(
            message: "Opening Driver Portal...",
          );
        });
    String userId = currentfirebaseUser == null ? '' : currentfirebaseUser.uid;
    Map carInfoMap = {
      "car_color": carColorTextEditingController.text,
      "car_number": carNumberTextEditingController.text,
      "car_model": carModelTextEditingController.text,
    };

    driversRef.child(userId).child("User's_car_details").set(carInfoMap);

    Navigator.pushNamedAndRemoveUntil(context, '/Driver', (route) => false);
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: kthemeColor,
      fontSize: 24,
      timeInSecForIosWeb: 3,
      textColor: Colors.white);
}
