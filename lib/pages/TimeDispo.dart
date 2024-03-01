import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modernlogintute/model/dechet.dart';
import 'package:http/http.dart' as http;
import '../components/MyAppBar.dart';
import '../components/my_textfield.dart';
import '../components/stepIndecator.dart';
import '../helpers/helpersVariables.dart';
import '../model/Localisation.dart';
import '../model/colis.dart';
import '../model/request.dart';
import '../model/user.dart';
import 'app.dart';
import 'demandePage.dart';

class TimeDispo extends StatefulWidget {
  late User user ;
  late List<Map<Dechet,int>> colis ;
  late LatLng? latlang ;
  TimeDispo({
    super.key ,
    required this.colis ,
    required this.latlang,
    required this.user,
  });

  @override
  State<TimeDispo> createState() => _TimeDispoState();
}

class _TimeDispoState extends State<TimeDispo> {
  DateTime? selectedDateTime;

  double calculatePoint(List<Map<Dechet, int>> list) {
    double totalPoint = 0.0;

    for (var item in list) {
      for (var dechet in item.keys) {
        double? weight = item[dechet]?.toDouble();
        double pointKg = dechet.pointsPerKg.toDouble();
        double point = weight! * pointKg;
        totalPoint += point;
      }
    }

    return totalPoint;
  }

  double calculatePoids(List<Map<Dechet, int>> list) {
    double totalWeight = 0.0;
    for (var item in list) {
      for (var weight in item.values) {
        totalWeight += weight.toDouble() ;
      }
    }
    return totalWeight;
  }

  Future<void> addColis(Map<Dechet , int> list , int idRequest) async {
    print(list);
    print(idRequest) ;
    final colis = Colis(
      id: null,
      idDechet: list.keys.first.id,
      idReq:idRequest ,
      poidsEstimee: list.values.first.toDouble() ,
      poidsReel: null ,
    ) ;
    print(colis.toString()) ;

    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = <String, String>{
      'id_dechet': colis.idDechet.toString(),
      'id_req':colis.idReq.toString() ,
      'poids_estimee': colis.poidsEstimee.toString() ,
    };

    final url = Uri.parse('${ENV_variables.API_PATH}/colis/add.php');
    final response = await http.post(
      url ,
      headers: headers,
      body: body,
    );
    if (response.statusCode == 201) {
      print("colis added successfully");
    } else {
      print('Errorer: ${response.statusCode} + ${response.body}');
    }
  }

  Future<bool> postRequest ( List<Map<Dechet , int>> list  , int? id , DateTime? date ,Localisation? local ) async {
    print(list.toString() + "    " + id.toString() + "   " + date.toString() + "  " + local!.lanLong() ) ;
    double point  = calculatePoint(list.cast<Map<Dechet, int>>()) ;
    final request  = Request(
      point: point,
      clientId: id ,
      date:  date ,
      status: false ,
      location: local.lanLong()  ,
    ) ;
    print(request.toString());
    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    print(request.date.toString()) ;
    final body = <String, String>{
      'id_client': request.clientId.toString()  ,
      'point': request.point.toString(),
      'date': request.date.toString(),
      'status': request.status.toString(),
      'location' : request.location.toString() ,
    };
    final url = Uri.parse('${ENV_variables.API_PATH}/request/add.php');
    final response = await http.post(
      url ,
      headers: headers,
      body: body,
    );
    if (response.statusCode == 201) {
      print("request added successfully");
      print(response.body) ;
      final responseData = json.decode(response.body);
      final requestId = responseData['requestId'];

      for (var colis in list) {
        addColis(colis.cast<Dechet, int>(),requestId) ;
      }
      return true ;
    } else {
      print('Error: ${response.statusCode} + ${response.body}');
      return false ;
    }
  }


  Future<Localisation> postLocation(String adresse, LatLng? latlang, int? id) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final body = <String, String?>{
      'id_citoyen': id.toString(),
      'adresse': adresse,
      'latitude': latlang?.latitude.toString(),
      'longitude': latlang?.longitude.toString(),
    };
    final url = Uri.parse('${ENV_variables.API_PATH}/user_loc/add-loc.php');
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
      print("Request added successfully");
      print(response.body);

      final responseData = json.decode(response.body);
      final locationBody = responseData['location'];

      // Create an empty Localisation instance
      Localisation localisation = Localisation();

      // Populate the instance attribute by attribute and handle errors
      try {
        localisation.id = locationBody['id'];
        localisation.idCitoyen = locationBody['id_citoyen'];
        localisation.adresse = locationBody['adresse'];
        localisation.latitude = locationBody['latitude'];
        localisation.longitude = locationBody['longitude'];
        localisation.createdAt = DateTime.parse(locationBody['created_at']);
      } catch (e) {
        print('Error populating Localisation instance: $e');
      }
      print("added succefly ") ;
      return localisation;

    } else {
      print('Error: ${response.statusCode} + ${response.body}');
      return Localisation(); // Return an empty instance in case of error
    }
  }

  final adresseController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(leading: Image.asset('lib/images/logo.png')),
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
            Center(
              child:SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const StepIndicator(currentStep: 2),
                    const SizedBox(height: 100,),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align children to start (left to right)
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Votre adresse: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          MyTextField(
                            editingFinish: () => {},
                            controller: adresseController,
                            hintText: "Votre adresse spécifique",
                            obscureText: false,
                            isValid: true,
                          ),
                        ],
                      ),
                    ),
                    DateTimeDropdown(
                      selectedDateTime: selectedDateTime,
                      onChanged: (DateTime? newValue) {
                        setState(() {
                          selectedDateTime = newValue;
                        });

                      },
                    ),
                    const SizedBox(height: 80,) ,
                    InkWell(
                      onTap: ()async{
                        var location = await postLocation(adresseController.text, widget.latlang, widget.user.id) ;
                        if (await postRequest(widget.colis,widget.user.id, selectedDateTime, location) ) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage(user: widget.user,index: 1,)),
                                (route) => false,
                          );
                        } else {
                          (print("error")) ;
                        };
                      },
                      child: Container(
                        width: 190,
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
                        child: const Text("VALIDER LA DEMADNE",textAlign: TextAlign.center,style: TextStyle(
                          fontFamily: 'InterTight',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: 3,
                        ),),
                      ),

                    ),
                    const SizedBox(height: 150,)
                  ],

                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DateTimeDropdown extends StatefulWidget {
  final DateTime? selectedDateTime;
  final ValueChanged<DateTime?> onChanged;

  DateTimeDropdown({
    required this.selectedDateTime,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<DateTimeDropdown> createState() => _DateTimeDropdownState();
}

class _DateTimeDropdownState extends State<DateTimeDropdown> {
 /* late List<DateTime> _initialSelectedDateTime= [];

  @override
  void initState() {
    setState(() {
      _initialSelectedDateTime = widget.dateTimeList;
    });
    super.initState();
  }*/
  Future<List<DateTime>> getTimeDispo() async {
    final List<DateTime> dateDispo = [];
    final url = Uri.parse('${ENV_variables.API_PATH}/date_dispo/get.php');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = response.body;

        if (responseBody.isNotEmpty) {
          final requestData = json.decode(responseBody);

          if (requestData != null && requestData is List) {
            for (var requestMap in requestData) {
              final dateString = requestMap["date_disponible"];
              final dateTime = DateTime.parse(dateString);
              dateDispo.add(dateTime);
            }
          } else {
            print('Invalid response data format.');
          }
        } else {
          print('Response body is empty.');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

    return dateDispo;
  }
  late List<DateTime> timeDispo = [] ;

  void fetchData()async{
    timeDispo = await getTimeDispo();
  }
  @override
  void initState() {
    setState(() {
      fetchData();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      height: 170,
      width: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white.withOpacity(0.6),
            Colors.green.withOpacity(0.3),
          ],
        ),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 18.0),
                      child: Text(
                        'Time Disponible: ',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            fontFamily: "KoHo",
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 30),
                  ],
                ),
              ),
              Container(
                width: 280,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.green.withOpacity(0.3),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButton<DateTime>(
                  value: widget.selectedDateTime,
                  onChanged: widget.onChanged,
                  items: [
                    const DropdownMenuItem<DateTime>(
                      value: null,
                      child: Text('Choisir un temps                      '),
                    ),
                    ...timeDispo.map((DateTime dateTime) {
                      final formattedDateTime =
                      DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
                      return DropdownMenuItem<DateTime>(
                        value: dateTime,
                        child: Text(formattedDateTime),
                      );
                    }).toList(),
                  ],
                  dropdownColor: const Color(0xFF2FDDAE),
                  elevation: 2,
                  underline: const SizedBox(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}


