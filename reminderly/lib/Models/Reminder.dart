class Reminder {
  List<Reminders> reminders;

  Reminder({this.reminders});

  Reminder.fromJson(Map<String, dynamic> json) {
    if (json['reminders'] != null) {
      reminders = <Reminders>[];
      json['reminders'].forEach((v) {
        reminders.add(new Reminders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reminders != null) {
      data['reminders'] = this.reminders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reminders {
  int id;
  String todo;
  String date;
  String time;
  String specialNotes;
  String userId;
  String createdAt;
  String updatedAt;
  // ignore: non_constant_identifier_names
  String session_id;
  User user;

  Reminders(
      {this.id,
      this.todo,
      this.date,
      this.time,
      this.specialNotes,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.user,
      // ignore: non_constant_identifier_names
      this.session_id});

  Reminders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    todo = json['todo'];
    date = json['date'];
    time = json['time'];
    specialNotes = json['special_notes'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    session_id = json['session_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['todo'] = this.todo;
    data['date'] = this.date;
    data['time'] = this.time;
    data['special_notes'] = this.specialNotes;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['session_id'] = this.session_id;
    return data;
  }
}

class User {
  int id;
  String firstname;
  String lastname;

  User({this.id, this.firstname, this.lastname});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    return data;
  }
}
