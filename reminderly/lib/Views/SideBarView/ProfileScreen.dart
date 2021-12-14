import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';
import 'package:reminderly/Controllers/HTTP%20Responses/User_API_Response.dart';
import 'package:reminderly/Controllers/Helpers/HelperController.dart';
import 'package:reminderly/Controllers/Services/User_services.dart';
import 'package:reminderly/Models/User.dart';
import 'package:reminderly/Models/Widgets/CustomProgressIndicator.dart';
import 'package:reminderly/Models/Widgets/TextFields.dart';
import 'package:reminderly/Views/LoginScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with HelperController {
  User user;
  bool _loading = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _imageFile;
  // final _picker = ImagePicker();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  UserServices _userController = UserServices();
  Timer timer;

  /// ******* Get User Details **********/
  Future<void> getUserDetails() async {
    var response = await UserClient().getUserDetails().catchError(handleError);
    if (response == null) return response;
    var res = JsonDecoder().convert(response) as Map<String, dynamic>;
    // ignore: unnecessary_cast
    var responseJson =
        // ignore: unnecessary_cast
        User.fromJson(res['user']) as User;
    // ignore: unnecessary_cast
    // print(responseBody.user!.firstname);
    print(res['user']);
    print(response);
    print(responseJson.email);
    if (mounted) {
      setState(() {
        user = responseJson;
        _firstnameController.text = responseJson.firstname ?? '';
        _lastnameController.text = responseJson.lastname ?? '';
        _phoneController.text = responseJson.phone ?? '';
        _loading = false;
      });
    }
    // print(responseJson.users);
  }

  Future getImage() async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getUserDetails();
      timer = Timer.periodic(Duration(seconds: 10), (timer) {
        getUserDetails();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void updateProfile() {
    _userController.updateUserDetails(
        _firstnameController.text.trim(),
        _lastnameController.text.trim(),
        _phoneController.text.trim(),
        getStringImage(_imageFile));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(children: [
        _loading
            ? SingleChildScrollView(
                child: Center(
                  child: CustomProgressIndicator(),
                ),
              )
            : RefreshIndicator(
                color: kMaroon,
                backgroundColor: kBLue,
                onRefresh: getUserDetails,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: GestureDetector(
                      child: Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                            border: Border.all(color: kIndigo, width: 5),
                            borderRadius: BorderRadius.circular(120),
                            image: _imageFile == null
                                ? user.image != null
                                    ? DecorationImage(
                                        image: NetworkImage('${user.image}'),
                                        fit: BoxFit.cover)
                                    : null
                                : DecorationImage(
                                    image: FileImage(_imageFile ?? File('')),
                                    fit: BoxFit.cover),
                            color: kMaroon),
                        child: Center(
                          child: user.emailVerifiedAt != null
                              ? Icon(Icons.verified_rounded,
                                  color: kBLue, size: 115)
                              : Icon(Icons.no_accounts_rounded,
                                  color: kBLue, size: 115),
                        ),
                      ),
                      onTap: () {
                        getImage();
                      },
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: user.emailVerifiedAt == null
                            ?
                            // ignore: deprecated_member_use
                            RaisedButton(
                                hoverColor: kMaroon,
                                elevation: 5,
                                textColor: Colors.white,
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _userController.verifyUser();
                                  }
                                },
                                color: kBLue,
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      'Verify',
                                      style: kFlatButtonBold,
                                    ),
                                  ),
                                  width: 140,
                                ))
                            : Container()),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: kMaroon, width: 2),
                            boxShadow: [
                              BoxShadow(
                                  color: kMaroon,
                                  spreadRadius: 5,
                                  blurRadius: 5.0,
                                  offset: Offset(5, 18))
                            ],
                            color: kIndigo,
                            borderRadius: BorderRadius.circular(60)),
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Card(
                              color: kIndigo,
                              shadowColor: kMaroon,
                              borderOnForeground: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(50),
                                    topLeft: Radius.circular(50),
                                    bottomRight: Radius.circular(50),
                                    topRight: Radius.circular(50)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DynamicTextField(
                                        myValidator: (value) => value.isEmpty
                                            ? 'Invalid First Name'
                                            : null,
                                        myController: _firstnameController,
                                        preferredInput: TextInputType.text,
                                        preIcon: Icon(
                                          FontAwesomeIcons.user,
                                          color: Colors.white,
                                        ),
                                        label: 'First Name....'),
                                    SizedBox(height: 10),
                                    DynamicTextField(
                                        myValidator: (value) => value.isEmpty
                                            ? 'Invalid Last Name'
                                            : null,
                                        myController: _lastnameController,
                                        preferredInput: TextInputType.text,
                                        preIcon: Icon(
                                          FontAwesomeIcons.userAlt,
                                          color: Colors.white,
                                        ),
                                        label: 'Last Name....'),
                                    SizedBox(height: 10),
                                    DynamicTextField(
                                        myValidator: (value) => value.isEmpty
                                            ? 'Invalid Phone'
                                            : null,
                                        myController: _phoneController,
                                        preferredInput: TextInputType.phone,
                                        preIcon: Icon(
                                          FontAwesomeIcons.phoneAlt,
                                          color: Colors.white,
                                        ),
                                        label: 'Phone number....'),
                                    // SizedBox(height: 5),
                                    // Center(
                                    //   child: Text(
                                    //     "Joined on: ${user!.createdAt}.",
                                    //     style: kFlatButton,
                                    //   ),
                                    // ),
                                    // SizedBox(height: 5),
                                    // Center(
                                    //   child: Text(
                                    //     "Last Updated: ${user!.createdAt}.",
                                    //     style: kFlatButton,
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: Column(
                        children: [
                          // ignore: deprecated_member_use
                          RaisedButton(
                              hoverColor: kMaroon,
                              elevation: 5,
                              textColor: Colors.white,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  updateProfile();
                                }
                              },
                              color: kBLue,
                              child: Container(
                                child: Center(
                                  child: Text(
                                    'Update',
                                    style: kFlatButtonBold,
                                  ),
                                ),
                                width: 100,
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          // ignore: deprecated_member_use
                          RaisedButton(
                              hoverColor: kIndigo,
                              elevation: 5,
                              textColor: Colors.white,
                              onPressed: () {
                                _logout();
                              },
                              color: kMaroon,
                              child: Container(
                                child: Center(
                                  child: Text(
                                    'Logout',
                                    style: kFlatButtonBold,
                                  ),
                                ),
                                width: 100,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ]),
    );
  }

  void _logout() {
    _userController.logoutUser();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
  }
}
