import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import the required package
import 'package:modernlogintute/pages/startFile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/MyAppBar.dart';
import 'model/user.dart';
import 'pages/sign_page.dart';
import 'pages/login_page.dart';
import 'pages/welcomePage.dart';
import 'package:provider/provider.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasOpenedBefore = prefs.getBool('hasOpenedBefore') ?? false;

  runApp(MyApp(hasOpenedBefore: hasOpenedBefore));

}

class MyApp extends StatelessWidget {
  final bool hasOpenedBefore;

  const MyApp({Key? key, required this.hasOpenedBefore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserState()), // Add this line
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Set status bar color as transparent
          statusBarIconBrightness: Brightness.light, // Set status bar icons to be dark
        ),
        child: MaterialApp(
          navigatorObservers: [routeObserver],
          debugShowCheckedModeBanner: false,
          initialRoute: hasOpenedBefore ? '/start_page' : '/',
          routes: {
            '/': (context) => WelcomeScreen(hasOpenedBefore: hasOpenedBefore),
            '/start_page': (context) => const StartScreen(),
            '/log_in': (context) => const LoginPage(),
            '/Sign_up': (context) => SignPage(),
          },
        ),
      ),
    );
  }
}
