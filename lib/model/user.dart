import 'package:flutter/cupertino.dart';

class User {
  final int? id ;
  final String? name;
  final String? lastName;
  final String? mobile;
  final String? email;
  final String? psw;
  final int? point ;
  User({
    this.id ,
    this.name,
    this.lastName,
    this.mobile,
    this.email,
    this.psw,
    this.point
  });

  Map<String, dynamic> toJson() {
    return {
      'id' : id ,
      'name': name,
      'lastName': lastName,
      'mobile': mobile,
      'email': email,
      'psw': psw,
      'point' : point,
    };
  }
  @override
  String toString() {
    if (id== null &&name == null && lastName == null && mobile == null && email == null && psw == null && point == null){return 'no user in this object';}
    return 'User: {id:$id , name: $name, lastName: $lastName, mobile: $mobile, email: $email, psw: $psw , point:$point}';
  }
}


class UserState extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
