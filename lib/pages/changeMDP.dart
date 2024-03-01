import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_button.dart';

import '../components/MyAppBar.dart';
import '../components/my_textfield.dart';
import '../helpers/helpersVariables.dart';
import '../model/user.dart';
import 'package:http/http.dart' as http;
class ChangePassword extends StatefulWidget {
  final User user;

  ChangePassword({required this.user});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final oldPasswordController = TextEditingController() ;
  final newPasswordController = TextEditingController() ;
  final ConfirmationController = TextEditingController() ;

  Future<bool> changePSW(User u , String oldPassword , String newPassword) async {
    print(u.id.toString());
    print(oldPassword) ;
    print(newPassword) ;

    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = <String, String>{
      'previousPassword': oldPassword,
      'newPassword': newPassword,
    };

    final response = await http.put(
      Uri.parse('${ENV_variables.API_PATH}/user/update_psw.php?id=${u.id}'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 204) {
      print("password changed successfully");
      return true;
    } else {
      print('Error: ${response.statusCode} + ${response.body}');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar:CustomAppBar(leading: Image.asset('lib/images/logo.png'),),
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
        child: Stack(
          children: [
            Image.asset("lib/images/background.png"),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Changer votre mot de passe " , style: TextStyle(color: Colors.black,fontFamily: "KoHo",fontWeight: FontWeight.w500 , fontSize: 24),) ,
                  const SizedBox(height: 50),
                  MyTextField(
                    editingFinish: ()=>{},
                    controller: oldPasswordController,
                    hintText: "Mot de passe Président",
                    obscureText: true,
                    isValid: true,
                  ),

                  const SizedBox(height: 20),
                  MyTextField(
                    editingFinish: ()=>{},
                    controller: newPasswordController,
                    hintText: "Neaveau Password",
                    obscureText: true,
                    isValid: true,
                  ),

                  const SizedBox(height: 20),
                  MyTextField(
                    editingFinish: ()=>{},
                    controller: ConfirmationController,
                    hintText: "Confirmer mot de passe ",
                    obscureText: true,
                    isValid: true,
                  ),
                  const SizedBox(height: 30,) ,

                    MyButton(
                      onTap: () {
                         String newPSW = newPasswordController.text ;
                         String oldPSW = oldPasswordController.text ;
                         String confiramtionPSW = ConfirmationController.text ;
                         newPSW == confiramtionPSW ? changePSW(widget.user , oldPSW , newPSW) : print("confiramtion is rong ") ;
                      },
                      innerText: 'Changer',
                      ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

