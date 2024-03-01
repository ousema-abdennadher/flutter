import 'package:flutter/material.dart' ;
import 'package:lottie/lottie.dart' ;
class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super (key: key);

  @override
  _Page1State createState() => _Page1State();
}
  class _Page1State extends State<Page1> {

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.transparent ,
          body:  Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF80EDC7), // First color - #80edc7
                  Color(0xFF4CA2D2), // Second color - #4ca2d2
                ],
              ),
            ),
            child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.network('https://assets6.lottiefiles.com/packages/lf20_g0rjjzet.json'),
                const Text('Mrarre de ramasser vos poubelles tout seul ?',
                  style: TextStyle(
                      color: Colors.white ,
                      fontSize: 15.0 ,
                      letterSpacing: 1.0 ,
                      fontFamily: "InterLight" ,
                      fontWeight: FontWeight.w500
                  ,
                  ),
                )
              ],
            ) ,
        ),
          )
      );
    }
  }