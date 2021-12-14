import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Controllers/Helpers/HelperController.dart';
import 'package:reminderly/Controllers/Services/User_services.dart';
import 'package:reminderly/Models/User.dart';

// ignore: must_be_immutable
class ContactProfile extends StatefulWidget {
  User user;
  ContactProfile({this.user});

  @override
  _ContactProfileState createState() => _ContactProfileState();
}

class _ContactProfileState extends State<ContactProfile> with HelperController {
  String createdDate = '';
  UserServices _serviceCotroller = new UserServices();
  String buttonText = 'Add/Remove';

  void convertDates() {
    String createdAt = widget.user.createdAt.toString();
    DateFormat inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss ');
    DateTime input1 = inputFormat.parse(createdAt);
    String createdAtDate = DateFormat.yMMMd('en_US').format(input1).toString();

    setState(() {
      createdDate = createdAtDate;
    });
  }

  @override
  void initState() {
    if (mounted) {
      convertDates();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kMaroon,
                  kBLue,
                  kMaroon,
                  kIndigo,
                  kMaroon,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: widget.user.image == null
                              ? Icon(Icons.person, color: kBLue, size: 100)
                              : Image.network(widget.user.image.toString()),
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            border: Border.all(color: kIndigo, width: 5),
                            borderRadius: BorderRadius.circular(120),
                            color: kMaroon,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: kIndigo, width: 3),
                              borderRadius: BorderRadius.circular(40),
                              color: kMaroon,
                              gradient: LinearGradient(
                                colors: [
                                  kIndigo,
                                  kMaroon,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            height: MediaQuery.of(context).size.height / 1.8,
                            width: MediaQuery.of(context).size.width / 1.8,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person,
                                          size: 25, color: kBLue),
                                      SizedBox(width: 10),
                                      Text(
                                        'Name: ' +
                                            "${widget.user.firstname}" +
                                            ' ' +
                                            "${widget.user.lastname}",
                                        style: kSmallText,
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.phone, size: 25, color: kBLue),
                                      SizedBox(width: 10),
                                      Text(
                                        'Phone: ' + "${widget.user.phone}",
                                        style: kSmallText,
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.email, size: 25, color: kBLue),
                                      SizedBox(width: 10),
                                      Text(
                                        'Email: ' + "${widget.user.email}",
                                        style: kSmallText,
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.date_range_rounded,
                                          size: 25, color: kBLue),
                                      SizedBox(width: 10),
                                      Text(
                                        'Joined: ' + '$createdDate',
                                        style: kSmallText,
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      widget.user.emailVerifiedAt == null
                                          ? Icon(
                                              FontAwesomeIcons.questionCircle,
                                              size: 40,
                                              color: kBLue)
                                          : Icon(Icons.verified,
                                              size: 40, color: kBLue)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        // ignore: deprecated_member_use
                        RaisedButton(
                            hoverColor: kMaroon,
                            elevation: 5,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: kBLue,
                            child: Container(
                              child: Center(
                                child: Text(
                                  'Back',
                                  style: kFlatButtonBold,
                                ),
                              ),
                              width: 140,
                            )),
                        SizedBox(height: 10),
                        // ignore: deprecated_member_use
                        RaisedButton(
                            hoverColor: kIndigo,
                            elevation: 5,
                            textColor: Colors.white,
                            onPressed: () {
                              _serviceCotroller
                                  .toggleContact(widget.user.id ?? 0);
                            },
                            color: kMaroon,
                            child: Container(
                              child: Center(
                                child: Text(
                                  buttonText,
                                  style: kFlatButtonBold,
                                ),
                              ),
                              width: 160,
                            ))
                      ],
                    )
                  ],
                )
              ],
            )),
      ],
    );
  }
}
