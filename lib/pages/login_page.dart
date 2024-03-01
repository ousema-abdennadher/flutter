import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_button.dart';
import 'package:modernlogintute/components/my_textfield.dart';
//import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../helpers/helpersVariables.dart';
import '../model/user.dart';
import 'app.dart';
import 'forget_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // email editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<bool> logUser(String tel , String password) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = <String, String>{
      'tel': tel,
      'password': password,
    };
    final response = await http.post(
      Uri.parse('${ENV_variables.API_PATH}/user/login.php'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print("loged succefuly");
      return true ;
    } else {
      // Request failed, handle error
      print('Error: ${response.statusCode} + ${response.body}');
      return false ;
    }
  }

  Future<User> getUserByEmail(String tel) async {
    final url = Uri.parse('${ENV_variables.API_PATH}/user/get_tel.php?tel=$tel');
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


  bool _isValid = true;
  void _validateNumTel() {
    setState(() {
      _isValid = emailController.text.length == 8;
    });
  }
  void onFinishingEditing()=>{
    //validate the email
    _validateNumTel()
  };
  // log user in method
  // log user in method
  Future<void> logUserIn() async {
    // Capture the BuildContext
    final currentContext = context;

    onFinishingEditing(); // Invoke the onFinishingEditing method
    bool isLoggedIn = await logUser(emailController.text, passwordController.text);

    if (isLoggedIn) {
      // Fetch the user data
      User user = await getUserByEmail(emailController.text);

      // Set the user data in the UserState using Provider.of
      Provider.of<UserState>(currentContext, listen: false).setUser(user);

      // Navigate to HomePage
      Navigator.pushReplacement(
        currentContext,
        MaterialPageRoute(
          builder: (context) => HomePage(user: user,index: 0,),
        ),
      );
    } else {
      // Handle login failure if needed
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient:LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF80EDC7), // First color - #80edc7
              Color(0xFF4CA2D2), // Second color - #4ca2d2
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),

                // logo
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

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                const Text(
                  'Bienvenue à nouveau, vous nous avez manqué !',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 20),

                // email textfield
                MyTextField(
                  editingFinish: onFinishingEditing,
                  controller: emailController,
                  hintText: 'Num télephon',
                  obscureText: false,
                  isValid: _isValid ,
                  showPrefixIcon: true,
                  prefixIcon: const Icon(Icons.phone),
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  editingFinish: ()=>{},
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  isValid: true,
                  showPrefixIcon: true,
                  prefixIcon: const Icon(Icons.lock),
                ),

                const SizedBox(height: 10),

                // forgot password?
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>   ForgetPassword(),
                      ),
                    ) ;
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Colors.white ,
                              fontWeight: FontWeight.w300,
                              fontFamily: "InterTight" ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // sign in button
                MyButton(
                  onTap: logUserIn,
                  innerText: "Log in",
                ),

                const SizedBox(height: 40),

                // or continue with


                const SizedBox(height: 100),



                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Pas un membre ?',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "InterTight",
                          fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: ()=>{Navigator.pushNamed(context, '/Sign_up')},
                      child: const Text(
                        'Inscrivez-vous',
                        style: TextStyle(
                          color: Colors.green,//(== Colors.green.shade800 ,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
