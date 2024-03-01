import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modernlogintute/components/my_button.dart';
import 'package:modernlogintute/components/my_textfield.dart';
import 'package:http/http.dart' as http;
import '../helpers/helpersVariables.dart';
import '../model/user.dart';


class SendMessage extends StatelessWidget {
  User u ;
  SendMessage({required this.u , super.key});

  final titleController = TextEditingController() ;
  final descriptionController = TextEditingController() ;

  Future<bool> sendMssg(BuildContext context ,int? id, String title , String description) async {
    print(id.toString() + "  " + title + "  "+description) ;
    if (id == null || title == null || description == null) {
      print("invalid coordination ");
    }
    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = <String, String>{
      'titre': title,
      'description': description ,
      'id_citoyen': id.toString() ,
    };

    final response = await http.post(
      Uri.parse('${ENV_variables.API_PATH}/user_mssg/add.php'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
      print("messaged added successfully");
      showSuccessDialog(context);
      return true;
    } else {
      print('Error: ${response.statusCode} + ${response.body}');
      return false;
    }
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const  Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Icon(
                Icons.check_circle_outline, // "tic" icon
                color: Colors.green,
                size: 100,
              ),
               SizedBox(height: 16),
               Text(
                'Message added successfully!',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(color: Color(0xFF24306F))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
              "Envoyer un message" ,
              style:TextStyle(color:Colors.black )
          ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white60,
      body: Center(child:
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      FontAwesomeIcons.envelopeOpenText,
                      size: 100,
                      color: Color(0xFF24306F),//(== Colors.green.shade800
                    ),
                      const SizedBox(height: 30,),
                      MyTextField(
                          controller: titleController,
                          hintText: "Sujet",
                          obscureText: false,
                          isValid: true,
                          editingFinish: ()=>{} ,
                      ),
                      const SizedBox(height: 30,) ,
                    Padding(
                      padding:  const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        maxLines: 13,
                        controller: descriptionController,
                        obscureText: false,
                        onEditingComplete:  ()=>{} ,
                        decoration: InputDecoration(

                            enabledBorder:   OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const  BorderSide(color: Color(0xFFE0E0E0) ),
                            ),
                            focusedBorder:   OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const  BorderSide(color: Color(0xFF24306F) , width: 1.0),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintText:" description" ,
                            hintStyle: TextStyle(color: Colors.grey[500])

                        ),

                      ),
                    ),
                    const SizedBox(height: 25,),
                    MyButton(
                        onTap:() async {
                          if(await sendMssg(context ,u.id,titleController.text , descriptionController.text ) ) {
                            titleController.clear();
                            descriptionController.clear() ;
                          }
                        },
                        innerText: "Envoyer"
                    ),
                    const SizedBox(height: 50,),
                  ],
                ),
              )
        ,),
    );
  }
}
