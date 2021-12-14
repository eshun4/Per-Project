import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Controllers/HTTP%20Responses/User_API_Response.dart';
import 'package:reminderly/Controllers/Helpers/HelperController.dart';
import 'package:reminderly/Models/Sessions.dart';
import 'package:reminderly/Models/User.dart';
import 'package:reminderly/Models/Widgets/CustomProgressIndicator.dart';
import 'package:reminderly/Views/ReminderHistory.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';

class SharedScreen extends StatefulWidget {
  @override
  _SharedScreenState createState() => _SharedScreenState();
}

class _SharedScreenState extends State<SharedScreen> with HelperController {
  String query = '';
  Timer timer2;
  bool _loading = true;
  List<User> _contacts = [];
  Timer timer;
  List<Color> gradientColor = [
    kMaroon,
    kIndigo,
  ];
  int count = 5;

  Future<void> listentoPrivate({User user}) async {
    try {
      // String token = await getToken();
      PusherOptions options = PusherOptions(
        cluster: 'us2',
        encrypted: false,
      );
      FlutterPusher pusher = FlutterPusher('ac79680bbf11472dc16b', options,
          lazyConnect: true,
          enableLogging: true, onConnectionStateChange: (val) {
        print(val.currentState);
      }, onError: (err) {
        print(err.message);
      });
      Echo echo = new Echo({
        'broadcaster': 'pusher',
        'client': pusher,
        'forceTLS': true,
        // 'auth': {
        //   'headers': {
        //     'Authorization': 'Bearer $token',
        //   }
        // }
      });
      print(user.session.session.id);
      echo
          .channel('Shared-Reminders.' + user.session.session.id.toString())
          .listen('PrivateSharedReminderEvent', (event) {
        print(event);
      });
    } catch (e) {
      print(e);
    }
  }

//Get contacts
  void getAllContacts() async {
    var response = await UserClient().getContacts().catchError(handleError);
    if (response == null) return;
    // ignore: unnecessary_cast
    print(response);
    var res = jsonDecode(response);
    // print(res['Contacts']);
    var users = UserObject.fromJson(res);
    if (mounted) {
      setState(() {
        _contacts = users.contacts;
        _loading = _loading ? !_loading : _loading;
      });
    }
    // print(users.contacts);
  }

//Create User Session with Event
  void createUserSession(int userId) async {
    var response =
        await UserClient().createSession(userId).catchError(handleError);
    if (response == null) return;
    // print(response);
    // var res = jsonDecode(response);
    // print(res);
  }

  Future<void> _initPusher() async {
    try {
      PusherOptions options = PusherOptions(
          cluster: 'us2', host: 'ws-us2.pusher.com', activityTimeout: 1200000);
      FlutterPusher pusher = FlutterPusher('ac79680bbf11472dc16b', options,
          onConnectionStateChange: (val) {
        print(val.currentState);
      }, onError: (err) {
        print(err.message);
      });

      Echo echo = new Echo({
        'broadcaster': 'pusher',
        'client': pusher,
      });
      echo.channel('Shared-Reminders').listen('SessionEvent', (event) {
        print(event);
        var ses = Sessions.fromJson(event);
        print(ses.session.users);
        _contacts.forEach((element) {
          setState(() {
            element.session = ses;
            print(element.session.session.id);
          });
        });
        print(_contacts.first.session.session.id);
        print(_contacts.first.session.sessionBy);
      });
    } catch (e) {
      //Connect
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _initPusher();
      getAllContacts();
      timer = Timer.periodic(Duration(minutes: 1), (timer) {
        getAllContacts();
      });
    }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "Shared",
                        style: kLargeText,
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 5,
                  color: kMaroon,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: ListView.builder(
                      itemCount: _contacts.length,
                      itemBuilder: (context, index) {
                        final users = _contacts[index];
                        return GestureDetector(
                            child: buildUser(users),
                            onTap: () {
                              createUserSession(users.id.toInt() ?? 0);
                              Future.delayed(const Duration(seconds: 5), () {
                                listentoPrivate(user: users);
                              });
                              _openSharedReminderBottomSheet(userChosen: users);
                            });
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildUser(User user) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
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
                                  maxLines: 1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
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

  void _openSharedReminderBottomSheet({User userChosen}) {
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
    return SharedReminderHistory(
      user: user,
    );
  }
}
