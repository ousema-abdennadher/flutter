import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_button.dart';
import 'package:modernlogintute/components/my_textfield.dart';
import 'package:modernlogintute/model/user.dart';
import 'package:http/http.dart' as http;
import '../components/MyAppBar.dart';
import 'login_page.dart';
import '../helpers/helpersVariables.dart';

class SignPage extends StatefulWidget {

    SignPage({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
// text editing controllers
    final nomController = TextEditingController();

    final passwordController = TextEditingController();

    final numtelController = TextEditingController();

    final emailController = TextEditingController();

    final prenomController = TextEditingController();


    Future<bool> createUser(User u) async {
      print(u.toString());

      final Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final body = <String, String>{
        'name': u.name ?? "null",
        'lastName': u.lastName ?? "null",
        'mobile': u.mobile ?? "null",
        'email': u.email ?? "null",
        'password': u.psw ?? "null",
      };

      final response = await http.post(
        Uri.parse('${ENV_variables.API_PATH}/user/sign-up.php'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        print("Signed up successfully");
        return true;
      } else {
        print('Error: ${response.statusCode} + ${response.body}');
        return false;
      }
    }
// sign user in method
  void signUserIn() async {
    onFinishingEditing;
    String name = nomController.text;
    String lastName = prenomController.text;
    String email = emailController.text;
    String mobilePhone = numtelController.text;
    String psw = passwordController.text;

    // Make an API call using the values
    User u1 = User(name: name, lastName: lastName, mobile: mobilePhone, email: email, psw: psw);

    bool isSignedIn = await createUser(u1);

    if (isSignedIn) {
      print("true") ;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));// Close the dialog

      // Perform further actions for successful sign-up
    } else {
      print("laaaaaaaaaaaa") ;
      // Perform further actions for unsuccessful sign-up
    }
  }

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    numtelController.dispose() ;
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  bool _isValid = true;
  void _validateEmail() {
    setState(() {
      _isValid = EmailValidator.validate(emailController.text);
    });
  }
  void onFinishingEditing()=>{
    //validate the email
    _validateEmail()
  };
  // log user in method

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar:CustomAppBar(leading: Image.asset('lib/images/logo.png'),),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
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
              child :SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      const SizedBox(height: 15),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("lib/images/StartLogo.png", height: 85,),
                            const SizedBox(height: 5,),
                            Image.asset("lib/images/StartLogotext.png" , height: 80,),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Bienvenue à notre communauté !',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,

                        ),
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        editingFinish: ()=>{},
                          controller: nomController,
                          hintText: "Nom",
                          obscureText: false,
                          isValid: true,
                        showPrefixIcon: true,
                        prefixIcon: const Icon(Icons.person),
                      ),

                      const SizedBox(height: 20),
                      MyTextField(
                        editingFinish: ()=>{},
                          controller: prenomController,
                          hintText: "Prenom",
                          obscureText: false,
                          isValid: true,
                        showPrefixIcon: true,
                        prefixIcon: const Icon(Icons.drive_file_rename_outline_outlined),
                      ),

                      const SizedBox(height: 20),
                      MyTextField(
                        editingFinish: ()=>{},
                          controller: numtelController,
                          hintText: "num télephone",
                          obscureText: false,
                          isValid: true,
                        showPrefixIcon: true,
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        editingFinish: onFinishingEditing,
                        controller: emailController,
                        hintText: "email",
                        obscureText: false,
                        isValid: _isValid,
                        showPrefixIcon: true,
                        prefixIcon: const Icon(Icons.email),
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        editingFinish: ()=>{},
                          controller: passwordController,
                          hintText: "Mot de passe",
                          obscureText: true,
                          isValid: true,
                        showPrefixIcon: true,
                        prefixIcon: const Icon(Icons.lock),
                      ),

                      const SizedBox(height: 25),

                      MyButton(
                          onTap: signUserIn,
                          innerText: "Sign up"),
                      const SizedBox(height: 20),



                    ],
                  ),
              ),



            ),
          ),
        )
    );
  }
}