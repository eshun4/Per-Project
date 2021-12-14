import 'package:reminderly/Models/Sessions.dart';

class UserObject {
  String status;
  User user;
  String token;
  List<User> users;
  List<User> contacts;

  UserObject({this.status, this.user, this.token, this.users, this.contacts});

  UserObject.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['users'] != null) {
      users = <User>[];
      json['users'].forEach((v) {
        users.add(new User.fromJson(v));
      });
    }

    if (json['Contacts'] != null) {
      contacts = <User>[];
      json['Contacts'].forEach((v) {
        contacts.add(new User.fromJson(v));
      });
    }
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    if (this.contacts != null) {
      data['Contacts'] = this.contacts.map((v) => v.toJson()).toList();
    }
    data['token'] = this.token;
    return data;
  }
}

class User {
  int id;
  String firstname;
  String lastname;
  String email;
  String phone;
  String image;
  String emailVerifiedAt;
  String createdAt;
  String updatedAt;
  Pivot pivot;
  Sessions session;

  User({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.image,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.pivot,
    this.session,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
    session = json['session'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
    data['session'] = this.session;
    return data;
  }
}

class Pivot {
  String userId;
  String contactId;

  Pivot({this.userId, this.contactId});

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    contactId = json['contact_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['contact_id'] = this.contactId;
    return data;
  }
}
