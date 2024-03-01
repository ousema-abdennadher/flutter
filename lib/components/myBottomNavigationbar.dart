import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int selectedPage;
  final Function(int) onPageSelected;

  const MyBottomNavigationBar({
    required this.selectedPage,
    required this.onPageSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return BottomAppBar(
      elevation: 0,
      child: SizedBox(
        height: 78,
        width: width,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconBottomBar(
                  text: "Acceuil",
                  svgIcon: SvgPicture.asset(
                    'svg/home.svg',
                    height: 31,
                    width: 31,
                    color: selectedPage == 0 ? const Color(0xFF0d7d8e) : Colors.black,
                  ),
                  selected: selectedPage == 0,
                  onPressed: () => onPageSelected(0),
                  width: width,
                ),
                IconBottomBar(
                  text: "demande",
                  svgIcon: SvgPicture.asset(
                    'svg/sandwich.svg',
                    height: 31,
                    width: 31,
                    color: selectedPage == 1 ? const Color(0xFF0d7d8e) : Colors.black,
                  ),
                  selected: selectedPage == 1,
                  onPressed: () => onPageSelected(1),
                  width: width,
                ),
                IconBottomBar(
                  text: "compte",
                  svgIcon: SvgPicture.asset(
                    'svg/profile.svg',
                    height: 31,
                    width: 31,
                    color: selectedPage == 2 ? const Color(0xFF0d7d8e) : Colors.black,
                  ),
                  selected: selectedPage == 2,
                  onPressed: () => onPageSelected(2),
                  width: width,
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
  final bool selected;
  final Function() onPressed;
  final double width;

  const IconBottomBar({
    required this.text,
    required this.svgIcon,
    required this.selected,
    required this.onPressed,
    required this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Call the provided onPressed function when tapped
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: svgIcon,
          ),
          const SizedBox(height: 18),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              height: -1,
              color: selected ? const Color(0xFF0d7d8e) : Colors.black,
            ),
          ),
          Container(height: 7, width: (width / 3) - 10.0, color: selected ? const Color(0xFF0d7d8e) : Colors.transparent)
        ],
      ),
    );
  }
}



/*class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Es-tu sûr de vouloir quitter ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Annular'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _quitApp(); // Call the function to quit the app
              },
              child: const Text('Quitter'),
            ),
          ],
        );
      },
    );
  }
  void _quitApp() {
    exit(0); // This will quit the app on both Android and iOS
  }
  @override
  Widget build(BuildContext context) {
    return Container(
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
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 30,) ,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [BoxShadow(
                  color: Colors.white.withOpacity(0.4), // Shadow color with opacity
                  spreadRadius: 1, // How far the shadow should spread in all directions
                  blurRadius: 3, // The blur radius of the shadow
                  offset: const Offset(0, 3), // Offset of the shadow
                ),]
              ),
              child: IconButton(
                onPressed: () {
                  _showExitConfirmationDialog(context); // Show the exit confirmation dialog
                },
                icon: const Icon(
                  Icons.power_settings_new_rounded,
                  color: Colors.grey,
                  size: 36,
                ),
              ),
            ),
          ),
           Text("EXIT",style:
          TextStyle(
            letterSpacing: 5 ,
            fontSize: 22 ,
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontFamily: 'KoHo',
            shadows: [
              Shadow(
                color: Colors.white.withOpacity(0.4), // Shadow color and opacity
                offset: const Offset(0, 3), // Offset of the shadow from the text (horizontal, vertical)
                blurRadius: 5, // Blur radius to soften the shadow
              ),
            ],
          ))
        ],
      ),
    );
  }
}*/
