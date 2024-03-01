import 'package:flutter/material.dart';
import 'package:modernlogintute/pages/parametre.dart';
import 'package:modernlogintute/pages/transfert.dart';
import '../components/inviteésignup.dart';
import '../model/user.dart';
import 'changeMDP.dart';
import 'changeProfile.dart';
import 'login_page.dart';
import '../components/MyAppBar.dart';
import 'package:flutter_svg/svg.dart';

class Compte extends StatelessWidget {
  final User user ;
  const Compte({required this.user ,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:CustomAppBar(leading: Image.asset('lib/images/logo.png'),showBackArrow: false,),
      backgroundColor: Colors.transparent,
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
            Image.asset("lib/images/background.png"),
            (user.id != -1) ?
            Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "COMPTE",
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
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      'svg/bigprofile.svg',
                      height: 120,
                      width: 120,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "${user.name} ${user.lastName}",
                      style:const TextStyle(
                        fontFamily: "KoHo", // Replace with your font family
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                  ) ,
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeProfileInfo(user: user),
                        ),
                      );
                    },
                    child: const Padding(
                      padding:  EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.person,
                            size: 28,
                            color: Color(0xFF11270B),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "Gérer le profil",
                            style: TextStyle(
                              fontFamily: "KoHo", // Replace with your font family
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF11270B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Divider(height: 1, thickness: 1, color: Colors.black26),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePassword(user: user),
                        ),
                      );
                    },
                    splashColor: Colors.white60, // Set the splash color to white
                    child:const  Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.lock,
                            size: 28,
                            color: Color(0xFF11270B),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "Changer le mot de passe",
                            style: TextStyle(
                              fontFamily: "KoHo", // Replace with your font family
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF11270B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(right: 8.0 , left: 8.0),
                    child: Divider(height: 1,thickness: 1 , color: Colors.black26,),
                  ) ,
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>   Transfert(user: user,),
                        ),
                      ) ;

                    },
                    splashColor: Colors.white60 ,
                    child: const Padding(
                      padding:  EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.compare_arrows_rounded,
                            size: 30,
                            color:Color(0xFF11270B),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "Transfert Point ",
                            style: TextStyle(
                              fontFamily: "KoHo", // Replace with your font family
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color:Color(0xFF11270B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0 , left: 8.0),
                    child: Divider(height: 1,thickness: 1 , color: Colors.black26,),
                  ) ,
              InkWell(
                  onTap: () async {
                  bool? confirmLogout = await LogoutConfirmationDialog.show(context);
                  if (confirmLogout ?? false) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false,
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 30,
                      color:Color(0xFF11270B),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      "Déconnexion",
                      style: TextStyle(
                        fontFamily: "KoHo", // Replace with your font family
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF11270B),
                  ),
                ),
              ],
              ),
              ),
            ),const SizedBox(height: 75,)
                ],
              ),):const Center(child: GoToLogIn(),)
          ],
        ),
      ),
    );
  }
}
class LogoutConfirmationDialog {
  static Future<bool?> show(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Confirmation"),
          content: const Text("Êtes-vous sûr de vouloir vous déconnecter?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Annuler", style: TextStyle(color: Color(0xFF24306F)),),
              onPressed: () {
                Navigator.of(context).pop(null); // Return null when cancel button is pressed
              },
            ),
            TextButton(
              child: const Text("Déconnexion",style: TextStyle(color: Color(0xFF24306F)),),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true when logout button is pressed
              },
            ),
          ],
        );
      },
    );
  }
}


