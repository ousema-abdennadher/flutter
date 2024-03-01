import 'package:flutter/material.dart' ;
import 'package:lottie/lottie.dart' ;
class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super (key: key);

  @override
  _Page2State createState() => _Page2State();
}
class _Page2State extends State<Page2> {


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
                Color(0xFF4CA2D2), // Second color - #4ca2d2
                Color(0xFF80EDC7), // First color - #80edc7
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // Set the desired width and height of the Lottie animation
                  width: 280,
                  height: 280,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LottieBuilder.network(
                      'https://assets1.lottiefiles.com/packages/lf20_bfwx9qok.json',
                    ),
                  ),
                ),
                const Text("Notre objectif est de vous aider, vous et l'environnement, en ramassant vos déchets et en vous offrant des récompenses !",
                  style: TextStyle(
                      color: Colors.white ,
                      fontSize: 15.0 ,
                      letterSpacing: 1.0 ,
                      fontFamily: "InterLight" ,
                      fontWeight: FontWeight.w500
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ) ,
          ),
        )
    );
  }
}