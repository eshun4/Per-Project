import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rideboard/main.dart';
import 'package:rideboard/ui/components/Configmaps.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:rideboard/ui/components/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:rideboard/ui/components/progressIndicator.dart';

class ProfileImageUploadScreen extends StatefulWidget {
  @override
  _ProfileImageUploadScreenState createState() =>
      _ProfileImageUploadScreenState();
}

class _ProfileImageUploadScreenState extends State<ProfileImageUploadScreen> {
  File sampleImage;
  String url;
  String newurl;
  final Reference profileImageref =
      FirebaseStorage.instance.ref().child('Profile Images');
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
    image2 = AssetImage('assets/Wallpaper-3.png');
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
      color: kthemeColor,
      height: double.infinity,
      width: double.infinity,
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(image: image2, fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: sampleImage == null
                    ? CircleAvatar(
                        child: Text(
                          'Add an Image',
                          style: ktextTheme2,
                        ),
                        radius: 200)
                    : enableUpload(),
                //   child: CircleAvatar(
                // radius: 100,
                // backgroundImage: AssetImage('assets/PATTERN2-.png'),
              ),
              SizedBox(height: 15),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton1(
                      whenPressed: () {
                        getImagefromCamera();
                      },
                      colorChoice: kthemeColor.withOpacity(0.8),
                      yourConstraints:
                          BoxConstraints.expand(width: 170, height: 60),
                      widgetChoice: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Camera', style: kCustomButton2),
                          Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 35,
                          )
                        ],
                      ),
                    ),
                    CustomButton1(
                      whenPressed: () {
                        getImagefromGallery();
                      },
                      colorChoice: kthemeColor.withOpacity(0.8),
                      widgetChoice: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Gallery', style: kCustomButton2),
                          Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 35,
                          ),
                        ],
                      ),
                      yourConstraints:
                          BoxConstraints.expand(width: 170, height: 60),
                    )
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                child: Center(
                  child: CustomButton1(
                    whenPressed: () {
                      Navigator.of(context).pop();
                      updateProfileImage();
                    },
                    colorChoice: Colors.purple,
                    widgetChoice: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Upload', style: kCustomButton2),
                        Icon(
                          Icons.upload_rounded,
                          color: Colors.white,
                          size: 35,
                        ),
                      ],
                    ),
                    yourConstraints:
                        BoxConstraints.expand(width: 170, height: 60),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget enableUpload() {
    return Column(children: [Image.file(sampleImage, height: 330, width: 660)]);
  }

  Future getImagefromCamera() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      sampleImage = tempImage;
    });
  }

  Future getImagefromGallery() async {
    var tempImage2 = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage2;
    });
  }

  void uploadProfileImage() async {
    var timeKey = new DateTime.now();
    final UploadTask uploadTask =
        profileImageref.child(timeKey.toString() + '.jpg').putFile(sampleImage);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    url = imageUrl.toString();
    saveToDataBase(url);
  }

  void updateProfileImage() async {
    var timeKey = new DateTime.now();
    final UploadTask uploadTask =
        profileImageref.child(timeKey.toString() + '.jpg').putFile(sampleImage);
    var newimageUrl = await (await uploadTask).ref.getDownloadURL();
    newurl = newimageUrl.toString();

    updatetoDatabase(newurl);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingIndicator(
            message: "Applying Changes",
          );
        });
  }

  void updatetoDatabase(newurl) async {
    String userId = currentfirebaseUser == null ? '' : currentfirebaseUser.uid;
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyy');
    var formatTime = new DateFormat('EEE , hh:mm aaa');
    String newdate = formatDate.format(dbTimeKey);
    String newtime = formatTime.format(dbTimeKey);
    var newdata = {
      'image': newurl,
      'date': newdate,
      'time': newtime,
    };
    usersRef.child(userId).child("ProfileImage").update(newdata);
  }

  void saveToDataBase(url) {
    String userId = currentfirebaseUser == null ? '' : currentfirebaseUser.uid;
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyy');
    var formatTime = new DateFormat('EEE , hh:mm aaa');
    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    var data = {
      'image': url,
      'date': date,
      'time': time,
    };
    usersRef.child(userId).child("ProfileImage").set(data);
  }

  Future getImage() async {
    var pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = pickedFile;
    });
  }
}
