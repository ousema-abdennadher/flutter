import 'package:flutter/material.dart';

import '../components/MyAppBar.dart';
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent ,
        appBar: CustomAppBar(leading: Image.asset('lib/images/logo.png'),),
        body: Container(
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
        child: Stack(
          children: [
            Image.asset("lib/images/background.png") ,
            const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "NOTIFICATION",
                        style: TextStyle(
                          fontFamily: "KoHo",
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 5,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Divider(height: 1, thickness: 1, color: Colors.white,),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        )
    );
  }
}
