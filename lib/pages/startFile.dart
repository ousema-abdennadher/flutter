import 'package:flutter/material.dart' ;
import 'package:flutter_svg/svg.dart';
import 'package:modernlogintute/pages/login_page.dart';

import '../model/user.dart';
import 'app.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(12.0),
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
        child:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50,) ,
              Text(
                  "BIENVENUE À NOTRE COMMUNITY",
                  style: TextStyle(
                        color: Colors.white ,
                        fontFamily: "InterLight" ,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 4,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3), // Shadow color and opacity
                            offset: const Offset(0, 2), // Offset of the shadow from the text (horizontal, vertical)
                            blurRadius: 3, // Blur radius to soften the shadow
                      ),
                    ],
                  )
              ),
              Expanded(
                  child:Container(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("lib/images/StartLogo.png", height: 85,),
                        const SizedBox(height: 5,),
                        Image.asset("lib/images/StartLogotext.png" , height: 80,),
                      ],
                    ),
                  )
              ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconBottomBar(
                      text: "invité",
                      svgIcon: SvgPicture.asset(
                        'svg/bigprofile.svg',
                        height: 84,
                        width: 84,
                      ),
                      onPressed: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => HomePage(user: User(id: -1, name: "None", lastName: "None", mobile: "55666999", email:"no@no.com", psw: "000", point: 000,),index: 0,),
                        ),);
                      },
                    ),
                    IconBottomBar(
                      text: "Domicile",
                      svgIcon: SvgPicture.asset(
                        'svg/bighome.svg',
                        height: 84,
                        width: 84,
                      ),
                      onPressed: (){
                        Navigator.pushReplacement(
                          context, MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),);
                      },
                    ),
                  ],
              ),
               ),
              const SizedBox(height: 15,),
              const Divider(
                height: 1,
                thickness: 1,
                color: Colors.white,
              ) ,
              Container(
                height: 100,
                child: Image.asset("lib/images/StartIcons.png")
              )
            ],
          ),
        ),
      ),
    );
  }
}
class CustomButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.white,
      child: Container(
        width: 220,
        padding: const EdgeInsets.only(top: 16,bottom: 16,left: 30,right: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.transparent,
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              letterSpacing: 20,
              fontFamily: "InterTight",
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class IconBottomBar extends StatelessWidget {
  final String text;
  final SvgPicture svgIcon;
  final Function() onPressed;
  //final double width;

  const IconBottomBar({
    required this.text,
    required this.svgIcon,
    required this.onPressed,
    //required this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onPressed, // Call the provided onPressed function when tapped
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: svgIcon,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: "KoHo",
            fontWeight: FontWeight.w400,
            color: Colors.white ,
          ),
        ),
      ],
    );
  }
}