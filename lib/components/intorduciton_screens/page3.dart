import 'package:flutter/material.dart' ;
import 'package:lottie/lottie.dart' ;
class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super (key: key);

  @override
  _Page3State createState() => _Page3State();
}
class _Page3State extends State<Page3> {

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
                Container(
                  // Set the desired width and height of the Lottie animation
                  width: 280,
                  height: 280,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LottieBuilder.network(
                      'https://assets7.lottiefiles.com/packages/lf20_1UtXIhyBYP.json',
                    ),
                  ),
                ),
                const Text("Ensemble, nous pouvons améliorer l'environnement\ncommençons !",
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