import 'package:firebase_database/firebase_database.dart';
import 'package:rideboard/ui/components/Configmaps.dart';

class MyUsers {
  String uid;
  String firstname;
  String lastname;
  String email;
  String phone;
  String profileImage;
  String date;
  String time;
  String car_color;
  String car_model;
  String car_number;

  MyUsers({
    this.uid,
    this.email,
    this.firstname,
    this.lastname,
    this.phone,
  });

  MyUsers.fromDataSnapshot(DataSnapshot snapshotData) {
    uid = snapshotData.key;
    email = snapshotData.value[currentfirebaseUser.uid]["Email"];
    firstname = snapshotData.value[currentfirebaseUser.uid]["firstname"];
    lastname = snapshotData.value[currentfirebaseUser.uid]["lastname"];
    phone = snapshotData.value[currentfirebaseUser.uid]["Phone"];
    car_color = snapshotData.value[currentfirebaseUser.uid]
        ["User's_car_details"]['car_color'];
    car_model = snapshotData.value[currentfirebaseUser.uid]
        ["User's_car_details"]['car_model'];
    car_number = snapshotData.value[currentfirebaseUser.uid]
        ["User's_car_details"]['car_number'];
  }
}
