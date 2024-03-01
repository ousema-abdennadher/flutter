import 'package:flutter/material.dart';
import 'package:modernlogintute/pages/locations.dart';
import 'package:modernlogintute/pages/test.dart';
import '../components/myBottomNavigationbar.dart' ;
import '../model/user.dart';
import 'compte.dart';
import 'firstPage.dart';
import 'demandePage.dart';

class HomePage extends StatefulWidget {
  final User user;
  final int index ;

   HomePage({required this.user, required this.index ,Key? key}) : super(key: key);


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Widget> screens;
  late int selectedPage = widget.index;

  @override
  void initState() {
    super.initState();
    screens = [
      FirstPage(user: widget.user),
      DemandPage(user:widget.user ,),
      /*Test(user: widget.user)*/
      Compte(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedPage],
      bottomNavigationBar:  MyBottomNavigationBar(
        selectedPage: selectedPage,
        onPageSelected: (int index) {
          setState(() {
            selectedPage = index;
          });
        },

      ),
    );
  }
}
