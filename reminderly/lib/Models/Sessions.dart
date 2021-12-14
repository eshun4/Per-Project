class Sessions {
  Session session;
  int sessionBy;

  Sessions({this.session, this.sessionBy});

  Sessions.fromJson(Map<String, dynamic> json) {
    session =
        json['session'] != null ? new Session.fromJson(json['session']) : null;
    sessionBy = json['session_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.session != null) {
      data['session'] = this.session.toJson();
    }
    data['session_by'] = this.sessionBy;
    return data;
  }
}

class Session {
  int id;
  List<String> users;

  Session({this.id, this.users});

  Session.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    users = json['users'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['users'] = this.users;
    return data;
  }
}
