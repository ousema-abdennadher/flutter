import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_button.dart';
import 'package:modernlogintute/components/my_textfield.dart';

import '../components/MyAppBar.dart';
import 'get4DigetCode.dart';


class ForgetPassword extends StatefulWidget {

  ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPassword();
}

class _ForgetPassword extends State<ForgetPassword> {
  final nomController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(leading: Image.asset('lib/images/logo.png'),),
      backgroundColor: Colors.transparent,
      body:
      Container(
        decoration: const BoxDecoration(
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
        child:Stack(
          children: [
            Image.asset("lib/images/background.png"),
            Center(
              child: SingleChildScrollView (
                child:Center (
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [

                      // logo
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.lightBlue[100]?.withAlpha(70),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.lock_reset_rounded,
                            size: 150,
                            color: Color(0xFF24306F),
                          ),
                        ),
                      )
                      ,

                      const SizedBox(height: 50),
                      const SizedBox(height: 10),
                      const Padding(
                        padding:  EdgeInsets.all(15.0),
                        child: Text(
                          'Veuillez entrer votre adresse e-mail pour recevoir un code de vérification.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: "KoHo"
                          ),
                          textAlign: TextAlign.center,
                        )

                      ),

                      const SizedBox(height: 20),
                      MyTextField(controller: nomController, hintText: "Entrez votre email", obscureText: false, isValid: true, editingFinish:(){}),
                      const SizedBox(height: 75,),
                      MyButton(onTap: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>   ConfirmEmailScreen(),
                        ),
                      ) ;
                        }, innerText: "Send") ,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ) ;
  }
}