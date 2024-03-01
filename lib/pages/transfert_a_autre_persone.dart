import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../components/MyAppBar.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../helpers/helpersVariables.dart';
import '../model/user.dart';

class TransferAutre extends StatefulWidget {
  final User user ;
  const TransferAutre({super.key, required this.user});

  @override
  State<TransferAutre> createState() => _TransferAutreState();
}

class _TransferAutreState extends State<TransferAutre> {
  Future<bool> addTransfert(User u , String tel , int  point) async {
    //print(u.id.toString().runtimeType);
    if (u.point! < point) {return false ;}

    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = <String, String>{
      'id_client': u.id.toString(),
      'point': point.toString(),
      'tel_client_distination':tel,
    };

    final response = await http.post(
      Uri.parse('${ENV_variables.API_PATH}/transfert/transfertAutre.php'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
      print("added up successfully");
      return true;
    } else {
      print('Error: ${response.statusCode} + ${response.body}');
      return false;
    }
  }
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 50),
              SizedBox(height: 10),
              Text("Votre transformation est valide"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TransferAutre(user: widget.user)));// Close the dialog
              },
              child: Text("Terminé"),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final controller= TextEditingController();
    bool _isValid = true;
    void _validateNumTel() {
      setState(() {
        _isValid = controller.text.length ==8 ;
      });
    }

    final amountcontroller= TextEditingController();
    return Scaffold(
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
            Image.asset("lib/images/background.png"),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("VOTRE POINTS : ${widget.user.point}",
                    style: const TextStyle(fontFamily: "KoHO" ,fontWeight: FontWeight.w500 , fontSize: 28 ),) ,
                  const SizedBox(height: 60,),
                   const Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: [
                       Text("Montant a transferer",
                       style: TextStyle(fontFamily: "KoHO" ,fontWeight: FontWeight.w500 , fontSize: 24 ),),
                       SizedBox(width: 80,)
                     ],
                   ),
                   const SizedBox(height: 10,),
                  Padding(

                    padding: const EdgeInsets.all(22.0),
                    child: TextField(
                      controller: amountcontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.green, width: 1.0),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: 'Enter digits only',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  ),

                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text("choisir un Num tel a envoyer" , style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500 , fontFamily: "KoHo"),),
                      ) ,
                      SizedBox(width: 60,)
                    ],
                  ),
                  const SizedBox(height: 20),
                  MyTextField(controller: controller, hintText: "Enter a number", obscureText: false, isValid: _isValid, editingFinish: _validateNumTel),
                  const SizedBox(height: 20),
                  MyButton(
                    onTap: () async{
                      print("button taped") ;
                      bool isSuccess = await addTransfert(
                        widget.user,
                        controller.text,
                        int.parse(amountcontroller.text),
                      );
                      print(isSuccess) ;
                      if (isSuccess) {
                        _showSuccessDialog(context);
                      } else if (!isSuccess) {
                        Fluttertoast.showToast(
                          msg: "Error",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 3,
                        );
                      }
                    },
                    innerText: 'Envoyer',

                  ),
                  SizedBox(height: 80,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
