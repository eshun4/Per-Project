import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Controllers/HTTP%20Responses/User_API_Response.dart';
import 'package:reminderly/Controllers/Helpers/HelperController.dart';
import 'package:reminderly/Models/User.dart';
import 'package:reminderly/Models/Widgets/CustomProgressIndicator.dart';
import 'package:reminderly/Models/Widgets/TextFields.dart';
import 'package:reminderly/Views/ContactProfile.dart';

class SearchContactsScreen extends StatefulWidget {
  @override
  _SearchContactsScreenState createState() => _SearchContactsScreenState();
}

class _SearchContactsScreenState extends State<SearchContactsScreen>
    with HelperController {
  String query = '';
  Timer debouncer;
  bool _loading = true;
  List<User> _users = [];
  List<User> _userstoDisplay = [];
  Timer timer;
  List<Color> gradientColor = [
    kMaroon,
    kIndigo,
  ];

//Get Reminder
  Future<void> getAllUsers({String query}) async {
    var response = await UserClient().getAllUsers().catchError(handleError);
    if (response == null) return response;
    // ignore: unnecessary_cast
    print(response);
    var res = jsonDecode(response);
    var users = UserObject.fromJson(res);
    print(res['users']);
    if (mounted) {
      setState(() {
        _users = users.users;
        _userstoDisplay = _users;
        _loading = _loading ? !_loading : _loading;
      });
    }
    print(users.users);
  }

  @override
  void initState() {
    super.initState();
    // Get users Api Call goes here
    if (mounted) {
      getAllUsers();
      timer = Timer.periodic(Duration(minutes: 1), (timer) {
        getAllUsers();
      });
    }
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DynamicTextField2(
        onEntry: (text) {
          text = text.toLowerCase();
          setState(() {
            _userstoDisplay = _users.where((user) {
              var userName = user.firstname.toLowerCase() +
                  " " +
                  user.lastname.toLowerCase();
              return userName.contains(text);
            }).toList();
          });
        },
        label: 'Find...',
        maxLines: 1,
        preferredInput: TextInputType.text,
        preIcon: Icon(
          FontAwesomeIcons.search,
          color: kMaroon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _loading
            ? Center(child: CustomProgressIndicator())
            : Column(
                children: [
                  _searchBar(),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: ListView.builder(
                          itemCount: _userstoDisplay.length,
                          itemBuilder: (context, index) {
                            final users = _userstoDisplay[index];
                            return buildUser(users);
                          }),
                    ),
                  ),
                ],
              ));
  }

  Widget buildUser(User user) => Padding(
        padding: const EdgeInsets.all(2.0),
        child: GestureDetector(
          onTap: () {
            _openUserBottomSheet(userChosen: user);
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: kIndigo, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: gradientColor.last.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 5,
                    offset: Offset(4, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: gradientColor,
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                )),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      user.image == null
                          ? CircleAvatar(
                              radius: 30.0,
                              child: Center(
                                child: Icon(FontAwesomeIcons.user,
                                    size: 25, color: Colors.white),
                              ),
                            )
                          : CircleAvatar(
                              radius: 30.0,
                              backgroundImage: NetworkImage('${user.image}'),
                              backgroundColor: Colors.transparent,
                            ),
                      SizedBox(width: 10),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${user.firstname}' +
                                      ' ' +
                                      '${user.lastname}',
                                  style: kLargeText,
                                ),
                                Text(
                                  'Email:' + ' ' + user.email.toString(),
                                  style: kSmallText,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Phone:' + ' ' + user.phone.toString(),
                                      style: kSmallText,
                                    ),
                                    user.emailVerifiedAt == null
                                        ? Icon(FontAwesomeIcons.questionCircle,
                                            size: 15, color: kBLue)
                                        : Icon(Icons.verified,
                                            size: 15, color: kBLue)
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void _openUserBottomSheet({User userChosen}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        enableDrag: true,
        isDismissible: true,
        elevation: 5,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return bottomPopUpSheet(context, user: userChosen);
        });
  }

  Widget bottomPopUpSheet(BuildContext context, {User user}) {
    return ContactProfile(
      user: user,
    );
  }
}
