import 'dart:convert';

import 'package:flutter_call_plugin_example/frame/utils/local_storage.dart';

class Result {
  final int code;
  final String? content;
  final String? userId;

  Result(this.code, this.content, this.userId);
}

class User {
  String id;
  String name;
  String? key;
  String? navigate;
  String? file;
  String? media;
  String? token;
  bool audio;
  bool video;

  User.remote(
    this.id,
  )   : this.name = 'Unknown',
        this.audio = false,
        this.video = false;

  User.create(
    this.id,
    this.key,
    this.navigate,
    this.file,
    this.media,
    this.token,
  )   : this.name = 'Unknown',
        this.audio = false,
        this.video = false;

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        key = json['key'],
        navigate = json['navigate'],
        file = json['file'],
        media = json['media'],
        token = json['token'],
        this.audio = false,
        this.video = false;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'key': key,
        'navigate': navigate,
        'file': file,
        'media': media,
        'token': token,
      };
}

class DefaultData {
  static void loadUsers() {
    String? json = LocalStorage.getString('users');
    if (json != null && json.isNotEmpty) {
      var list = jsonDecode(json);
      for (var user in list) _users.add(User.fromJson(user));
    }
  }

  static void clear() {
    _users.clear();
    String json = jsonEncode(_users);
    LocalStorage.setString("users", json);
  }

  static set user(User? user) {
    if (user == null) return;
    _user = user;
    _users.removeWhere((element) => "${user.id}${user.name}${user.key}" == "${element.id}${element.name}${element.key}");
    _users.add(user);
    String json = jsonEncode(_users);
    LocalStorage.setString("users", json);
  }

  static User? get user => _user;

  static List<User> get users => _users;

  static User? _user;
  static List<User> _users = [];
}
