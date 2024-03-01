import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/MyAppBar.dart';
import '../components/my_button.dart';
import '../helpers/helpersVariables.dart';
import '../model/user.dart';
import 'package:http/http.dart' as http;

class ChangeProfileInfo extends StatefulWidget {
  final User user;

  ChangeProfileInfo({required this.user});

  @override
  _ChangeProfileInfoState createState() => _ChangeProfileInfoState();
}

class _ChangeProfileInfoState extends State<ChangeProfileInfo> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  Future<User> getUserById(int? id) async {
    final url = Uri.parse('${ENV_variables.API_PATH}/user/get_user.php?id=$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isNotEmpty) {
          final userData = json.decode(responseBody);
          //print(userData) ;
          if (userData != null) {
            final u1 = User(
                id : userData['id'] ,
                name: userData['nom'],
                lastName: userData['prenom'],
                mobile: userData['tel'],
                email: userData['email'],
                psw: userData['password'],
                point: userData['point']
            );
            print(u1.toString());
            return u1;
          } else {
            print('User data is null.');
          }
        } else {
          print('Response body is empty.');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return User();
  }

  Future<bool> changeUserInfo(User u , String name , String lastName , String mobile) async {
    print(u.id.toString());
    print(name) ;
    print(lastName) ;
    print(mobile) ;
    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = <String, String>{
      'name': name,
      'lastName': lastName,
      'mobile' : mobile ,
    };

    final response = await http.put(
      Uri.parse('${ENV_variables.API_PATH}/user/update.php?id=${u.id}'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 204) {
      print("User info changed successfully");
      return true;
    } else {
      print('Error: ${response.statusCode} + ${response.body}');
      return false;
    }
  }
  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.user.name!;
    _lastNameController.text = widget.user.lastName!;
    _mobileController.text = widget.user.mobile!;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  bool _isMobileValid(String value) {
    return value.length == 8;
  }

  bool _isNameValid(String value) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(leading: Image.asset('lib/images/logo.png'),),
      body: Container(
        decoration:  const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Color(0xFF2FDDAE), // First color - #80edc7
              Color(0xFF00818c),
              Color(0xFF2FDDAE), // Second color - #4ca2d2
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Image.asset("lib/images/background.png"),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100,),
                    const Icon(Icons.arrow_forward, size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      'Données personnelles',
                      style: TextStyle(fontSize: 28 , fontWeight: FontWeight.w500, fontFamily: "KoHo"),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Changer les informations ci-dessous',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: 'Nom',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(12.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: 'Prénom',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(12.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _mobileController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.greenAccent),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            focusedBorder:OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.greenAccent),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelText: 'Numéro de téléphone',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(12.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.greenAccent),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.greenAccent),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    MyButton(
                      onTap: () async {
                        if (_isNameValid(_firstNameController.text) &&
                            _isNameValid(_lastNameController.text) &&
                            _isMobileValid(_mobileController.text)) {
                          bool success = await changeUserInfo(
                            widget.user,
                            _firstNameController.text,
                            _lastNameController.text,
                            _mobileController.text,
                          );
                          if (success) {
                            // Handle success case
                            Provider.of<UserState>(context, listen: false).setUser(await getUserById(widget.user.id));
                            print('User info changed successfully');
                          } else {
                            // Handle failure case
                            print('Error occurred while changing user info');
                          }
                        }
                      },
                      innerText: "Save",
                    ),



                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

