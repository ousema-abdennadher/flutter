import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_button.dart';

import '../pages/login_page.dart';

class GoToLogIn extends StatelessWidget {
  const GoToLogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(12.0),
      height: 210,
      width: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white.withOpacity(0.6),
            Colors.green.withOpacity(0.3),
          ],
        ),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Veuillez vous connecter pour profiter pleinement de l\'expérience',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: "KoHo",
                      color: Colors.white),
                ),
              ),
              MyButton(onTap: (){
                Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),);
              }, innerText: "Log in",),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
