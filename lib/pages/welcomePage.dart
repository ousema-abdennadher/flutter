import 'package:flutter/material.dart';
import 'package:modernlogintute/pages/startFile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/intorduciton_screens/page1.dart';
import '../components/intorduciton_screens/page2.dart';
import '../components/intorduciton_screens/page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class WelcomeScreen extends StatefulWidget {
  final bool hasOpenedBefore;
  const WelcomeScreen({Key? key, required this.hasOpenedBefore}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void changeColor(){
    setState((){
      tapedColor = Colors.green ;
    }) ;
  }
  PageController controller = PageController() ;

  bool onLastPage = false ;
  Color tapedColor= Colors.black ;
  @override
  Widget build(BuildContext context) {
    if (widget.hasOpenedBefore) {
      print("Has been Opened : ${widget.hasOpenedBefore}");
      return const StartScreen();
    }else {
      print("Has been Opened : ${widget.hasOpenedBefore}");
      return Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: controller,
              //if it's the last page
              onPageChanged: (index) => {
                setState(() {
                  onLastPage = (index == 2); // gets the value of camaparison
                })
              },
              children: const [
                // Add your welcome pages here
                Page1(),
                Page2(),
                Page3(),
              ],
            ),
            // dot indicators
            Container(
              alignment: const Alignment(0, 0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => {controller.jumpToPage(2)},
                    child: const Text(
                      "skip",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: controller, // PageController
                    count: 3,
                    effect: const ExpandingDotsEffect(
                      dotColor: Colors.white,
                      activeDotColor:
                          Color(0xFF20E316), //<== Colors.green.shade800
                    ), // your preferred effect
                  ),
        GestureDetector(
          onTap: () async {
            if (onLastPage) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('hasOpenedBefore', true);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const StartScreen()),
              );
            } else {
              changeColor();
              controller.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              );
            }
          },
          child: Text(
            onLastPage ? "done" : "next",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "InterLight",
              fontWeight: FontWeight.w400,
            ),
          ),)
                ],
              ),
            )
          ],
        ),
      );
    }
  }
}

/*
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modernlogintute/pages/startFile.dart';
import '../components/intorduciton_screens/page1.dart';
import '../components/intorduciton_screens/page2.dart';
import '../components/intorduciton_screens/page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  PageController controller = PageController();
  bool onLastPage = false;
  Color tapedColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    if (isFirstLaunch) {
      // Show introduction screens on the first launch
      prefs.setBool('isFirstLaunch', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        // Check if it's the first launch
        future: SharedPreferences.getInstance().then(
              (prefs) => prefs.getBool('isFirstLaunch') ?? true,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final bool isFirstLaunch = snapshot.data!;
            if (isFirstLaunch) {
              // Show introduction screens
              return _buildIntroductionScreens();
            } else {
              // Show main content
              return _buildMainContent();
            }
          }
        },
      ),
    );
  }

  Widget _buildIntroductionScreens() {
    return PageView(
      controller: controller,
      onPageChanged: (index) {
        setState(() {
          onLastPage = (index == 2);
        });
      },
      children: const [
        Page1(),
        Page2(),
        Page3(),
      ],
    );
  }

  Widget _buildMainContent() {
    return Stack(
      children: [
        // Main content here
        // ...

        // Dot indicators and buttons
        Container(
          alignment: const Alignment(0, 0.9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // ...

              onLastPage
                  ? GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StartScreen(),
                    ),
                  );
                },
                child: const Text(
                  "done",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "InterLight",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
                  : GestureDetector(
                onTap: () {
                  changeColor();
                  controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                },
                child: const Text(
                  "next",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "InterLight",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}



*/
