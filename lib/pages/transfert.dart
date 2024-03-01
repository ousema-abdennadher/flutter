import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_button.dart';
import 'package:modernlogintute/components/my_textfield.dart';
import 'package:modernlogintute/pages/startFile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modernlogintute/pages/transfert_a_autre_persone.dart';
import '../components/MyAppBar.dart';
import '../helpers/helpersVariables.dart';
import '../model/user.dart';
import 'package:http/http.dart' as http;
class Transfert extends StatefulWidget {
  final User user;
  const Transfert({super.key, required this.user});
  @override
  _TransfertState createState() => _TransfertState();
}

class _TransfertState extends State<Transfert> {
  String dropdownValue = 'Donne';
  final TextEditingController _controller = TextEditingController();

  Future<bool> addTransfert(User u , String methode , int  point) async {
    //print(u.id.toString().runtimeType);
    if (u.point! < point) {return false ;}

    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = <String, String>{
      'methode': methode == 'Bonnde achat' ? 'BON_DACHAT' : 'DONNE',
      'id_client': u.id.toString(),
      'point': point.toString(),
    };

    final response = await http.post(
      Uri.parse('${ENV_variables.API_PATH}/transfert/add.php'),
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

  bool _isValid = true;
  void _validateNumTel() {
    setState(() {
      _isValid = int.parse(_controller.text) >=200 ;
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Transfert(user: widget.user)));// Close the dialog
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
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: CustomAppBar(leading: Image.asset('lib/images/logo.png'),),
      body: Container(
        decoration:  const BoxDecoration(
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
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("VOTRE POINTS : ${widget.user.point}",style: const TextStyle(fontFamily: "KoHO" ,fontWeight: FontWeight.w500 , fontSize: 28 ),) ,
                      const SizedBox(height: 100,),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text("choisir une méthode" , style:
                            TextStyle(fontSize: 24,fontWeight: FontWeight.w500 , fontFamily: "KoHo"),
                            ),
                          ) ,
                          Container(
                            padding: const EdgeInsets.only(left : 8.0 , right: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: <String>[
                                'Bonnde achat',
                                'Donne',
                              ]
                                  .map((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      MyTextField(controller: _controller, hintText: "Enter a number", obscureText: false, isValid: _isValid, editingFinish: _validateNumTel),
                      const SizedBox(height: 20),
                      MyButton(
                          onTap: () async {
                            print("button taped") ;
                            String selectedValue = dropdownValue;
                            int enteredNumber = int.tryParse(_controller.text) ?? 0;
                            print(enteredNumber);
                            print(selectedValue);
                            bool isSuccess = await addTransfert(
                              widget.user,
                              selectedValue,
                              enteredNumber,
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
                          innerText: 'Confirmer',

                          ),
                      const SizedBox(height: 130,) ,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                                "envoyer des points\n à un autre utilisateur",
                                textAlign: TextAlign.center,
                                style:TextStyle(fontSize: 18,fontWeight: FontWeight.w500 , fontFamily: "KoHo"),
                            ),
                            MyButton(onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>   TransferAutre(user: widget.user,),
                                ),
                              ) ;
                            }, innerText: "Transfert")

                          ],
                      ),
                        )


                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*If you want the user instance to be refreshed automatically from the database after making a transfer, you need to fetch the updated user data from the server and replace the existing user instance. You can do this using an API call to get the latest user data. Here's how you can achieve this:

1. Create a Function to Fetch User Data**: Create a function that fetches the user data from the server based on the user's ID.

2. **Refresh User Data After Transfer**: After making a successful transfer, call the function to fetch the user's updated data from the server and replace the existing user instance with the new data.

Here's a general idea of how you can implement this:

```dart
class _TransfertState extends State<Transfert> {
  // ... your existing code ...

  Future<void> _refreshUserData() async {
    try {
      // Fetch updated user data from the server using an API call
      User updatedUser = await fetchUserData(widget.user.id);

      // Update the user instance in the state
      setState(() {
        widget.user = updatedUser;
      });
    } catch (error) {
      // Handle error
    }
  }

  Future<bool> addTransfert(User u, String methode, int point) async {
    // ... your existing code ...

    if (isSuccess) {
      // Refresh the user data after successful transfer
      await _refreshUserData();
      return true;
    } else {
      // Handle error
      return false;
    }
  }

  // ... your existing code ...
}
```

In this example, the `_refreshUserData` function fetches the user's updated data from the server and replaces the existing user instance in the state. The function is called after a successful transfer using `_refreshUserData()`.

Keep in mind that the actual implementation of fetching user data will depend on your API structure and how you handle HTTP requests in your app. You can use libraries like `http` or `dio` to make API calls.

By refreshing the user data from the server, your user instance will always reflect the latest data stored in the database*/