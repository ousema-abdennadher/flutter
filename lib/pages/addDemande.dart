/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modernlogintute/model/Localisation.dart';
import 'package:modernlogintute/model/colis.dart';
import 'package:modernlogintute/model/request.dart';

import '../components/MyAppBar.dart';
import '../model/dechet.dart';
import '../model/user.dart';
import 'demandePage.dart';
import 'simulation.dart';

class AddDemande extends StatefulWidget {
  User user ;
  List<Map<Dechet, double>> list;

  AddDemande({required this.user , required this.list, Key? key}) : super(key: key);

  @override
  _AddDemandeState createState() => _AddDemandeState();
}

class _AddDemandeState extends State<AddDemande> {
  List<DateTime> dateDispo = [];
  DateTime? selectedDateTime;
  List<Localisation> userLocal =[] ;
  Localisation? selectedLocalisation ;
  Dechet? _selectedDechet;

  Future<void> addColis(Map<Dechet , double> list , int idRequest) async {
    print(list);
    print(idRequest) ;
    final colis = Colis(
        id: null,
        idDechet: list.keys.first.id,
        idReq:idRequest ,
        poidsEstimee: list.values.first ,
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

  Future<void> postRequest ( List<Map<Dechet , double>> list  , int? id , DateTime? date ,Localisation? local ) async {
    print(list.toString() + "    " + id.toString() + "   " + date.toString() + "  " + local!.lanLong() ) ;
    double point  = calculatePoint(list) ;
    final request  = Request(
      point: point,
      clientId: id ,
      date:  date ,
      status: false ,
      location: local.lanLong(),
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
        addColis(colis,requestId) ;
      }
    } else {
      print('Error: ${response.statusCode} + ${response.body}');
    }
  }
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final List<DateTime> timeDispo = await getTimeDispo();
    final List<Localisation> userLocalisations = await getUsersLocation(widget.user.id) ;
    setState(() {
      dateDispo = timeDispo;
      userLocal = userLocalisations ;
    });
  }
  Future<List<Localisation>> getUsersLocation(int? id) async {

    final List<Localisation> userLocations = [];
    final url = Uri.parse('${ENV_variables.API_PATH}/user-loc/get-loc.php?id=${id.toString()}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = response.body;

        if (responseBody.isNotEmpty) {
          final requestData = json.decode(responseBody);
          if (requestData != null && requestData is List) {
            for (var locationMap in requestData) {
              final userLocation = Localisation(
                id: locationMap['id'],
                idCitoyen: locationMap['id_citoyen'],
                adresse: locationMap['adresse'],
                codePostal: locationMap['code_postal'],
                region: locationMap['region'],
                ville: locationMap['ville'],
                titre: locationMap['titre'],
                latitude: locationMap['latitude'],
                longitude: locationMap['longitude'],
                createdAt: DateTime.parse(locationMap['created_at']),
              );
              userLocations.add(userLocation);
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
    return userLocations;
  }

  double calculatePoint(List<Map<Dechet, double>> list) {
    double totalPoint = 0.0;

    for (var item in list) {
      for (var dechet in item.keys) {
        double weight = item[dechet] ?? 0.0;
        double pointKg = dechet.pointKg.toDouble();
        double point = weight * pointKg;
        totalPoint += point;
      }
    }

    return totalPoint;
  }
  double calculatePoids(List<Map<Dechet, double>> list) {
    double totalWeight = 0.0;

    for (var item in list) {
      for (var weight in item.values) {
         totalWeight += weight ;
      }

    }
    return totalWeight;
  }

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

  void onItemSelected(Map<Dechet, double> selectedItem) {
    setState(() {
      widget.list.add(selectedItem);
    });
  }

  void onRemove(int index) {
    setState(() {
      widget.list.removeAt(index);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(leading: Image.asset('lib/images/logo.png'),),
      backgroundColor: Colors.grey[400],
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
        child: Column(
          children: [
            const SizedBox(height: 30,) ,
            const Padding(
              padding: EdgeInsets.only(right: 200.0),
              child: Text("Choisir un type : ",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,),),
            ),
            DisplayDemande(
              onItemSelected: onItemSelected,
              list: widget.list,
            ),
            SelectedItemWidget(
              selectedDechets: widget.list,
              onRemove: onRemove,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 150,) ,
                const Text(
                  'Besoin d\'aide ?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Simula(),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          widget.list = result;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF24306F),
                      shadowColor: Colors.grey[300],
                      elevation: 5,
                    ),
                    child: const Text('Simulation'),
                  ),
                ),

              ],
            ),
            DateTimeDropdown(
              dateTimeList: dateDispo,
              selectedDateTime: selectedDateTime,
              onChanged: (DateTime? newValue) {
                setState(() {
                  selectedDateTime = newValue;
                });
              },
            ),
            const SizedBox(height: 20,) ,
        LocationDropDown(
          userLocal: userLocal,
          selectedLocalisation: selectedLocalisation,
          onChanged: (Localisation? newValue) {
            setState(() {
              selectedLocalisation = newValue;
            });
          },
        ) ,
            const SizedBox(height: 20,) ,
            Container(
              margin: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  postRequest(widget.list, widget.user.id, selectedDateTime, selectedLocalisation);
                  DemandPage screen =context.findAncestorWidgetOfExactType<DemandPage>()!;
                  //screen.upgradeState() ;
                  Navigator.pop(context); // Add the Navigator.pop here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF24306F),
                  shadowColor: Colors.grey[300],
                  elevation: 5,
                ),
                child: const Text('Términer'),
              ),
            )


          ],
        ),
      ),
    );
  }
  getUsetLocal() {}
}

class DateTimeDropdown extends StatefulWidget {

  final List<DateTime> dateTimeList;
  final DateTime? selectedDateTime;
  final ValueChanged<DateTime?> onChanged;

  DateTimeDropdown({
    required this.dateTimeList,
    required this.selectedDateTime,
    required this.onChanged,
    Key? key,
  }) : super(key: key);
  @override
  _DateTimeDropdownState createState() => _DateTimeDropdownState();
}

class _DateTimeDropdownState extends State<DateTimeDropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 18.0, left: 30.0),
              child: Text(
                'Time Disponible: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black54, width: 1),
                boxShadow:  [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButton<DateTime>(
                value: widget.selectedDateTime,
                onChanged:widget.onChanged ,

                items: [
                  const DropdownMenuItem<DateTime>(
                    value: null,
                    child: Text('Choisir un temps'),
                  ),
                  ...widget.dateTimeList.map((DateTime dateTime) {
                    final formattedDateTime =
                    DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
                    return DropdownMenuItem<DateTime>(
                      value: dateTime,
                      child: Text(formattedDateTime),
                    );
                  }).toList(),
                ],
                dropdownColor: Colors.white,
                elevation: 2,
                underline: SizedBox(),
                // Hide the default underline
              ),

            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          widget.selectedDateTime != null
              ? widget.selectedDateTime.toString()
              : 'No date and time selected',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class LocationDropDown extends StatefulWidget {
  final List<Localisation> userLocal;
  Localisation? selectedLocalisation;
  final ValueChanged<Localisation?> onChanged;

  LocationDropDown({
    required this.userLocal,
    required this.selectedLocalisation,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<LocationDropDown> createState() => _LocationDropDownState();
}

class _LocationDropDownState extends State<LocationDropDown> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 18.0, left: 30.0),
          child: Text(
            'Localisation: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black54, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButton<Localisation>(
            value: widget.selectedLocalisation,
            onChanged: widget.onChanged ,
            items: [
              const DropdownMenuItem<Localisation>(
                value: null,
                child: Text('Choisir une localisation'),
              ),
              ...widget.userLocal.map((Localisation localisation) {
                return DropdownMenuItem<Localisation>(
                  value: localisation,
                  child: Text(localisation.titre ?? ''),
                );
              }).toList(),
            ],
            dropdownColor: Colors.white,
            elevation: 2,
            underline: SizedBox(),
            // Hide the default underline
          ),
        ),
      ],
    );
  }
}

class DisplayDemande extends StatefulWidget {

  final Function(Map<Dechet, double>) onItemSelected;
  List<Map<Dechet, double>> list;

  DisplayDemande({
    required this.onItemSelected,
    required this.list,
    Key? key,
  }) : super(key: key);

  @override
  _DisplayDemandeState createState() => _DisplayDemandeState();
}

class _DisplayDemandeState extends State<DisplayDemande> {
  int selectedItemId = 0;
  late List<Dechet> displayList = [];
  Dechet? _selectedDechet;
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDechets();
  }

  Future<void> fetchDechets() async {
    try {
      displayList = await getDechet();
    } catch (e) {
      print('Error fetching dechets: $e');
      displayList = [];
    }
    setState(() {});
  }



  Future<List<Dechet>> getDechet() async {
    final List<Dechet> dechet = [];
    final url = Uri.parse('${ENV_variables.API_PATH}/dechet/get_all.php');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = response.body;

        if (responseBody.isNotEmpty) {
          final dechetData = json.decode(responseBody);

          if (dechetData != null && dechetData is List) {
            for (var dechetMap in dechetData) {
              dechet.add(
                Dechet(
                  id: int.parse(dechetMap['id']),
                  poids: double.parse(dechetMap['poids']),
                  type: dechetMap['type'],
                  sousType: dechetMap['sous_type'],
                  objet: dechetMap['objet'],
                  pointKg: double.parse(dechetMap['point_kg']),
                ),
              );
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

    return dechet;
  }

  void onAjouterClicked() {
    if (_selectedDechet != null) {
      final quantity = double.parse(quantityController.text);
      final selectedDechet = {_selectedDechet!: quantity.toDouble()};
      widget.onItemSelected(selectedDechet);
      quantityController.clear();
      setState(() {
        _selectedDechet = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButton<int>(
                isExpanded: true,
                value: selectedItemId,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedItemId = newValue!;
                    _selectedDechet = displayList[selectedItemId];
                    print(_selectedDechet);
                  });
                },
                dropdownColor: Colors.white,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF24306F),
                ),
                underline: Container(),
                items: displayList.map<DropdownMenuItem<int>>(
                      (Dechet dechet) {
                    return DropdownMenuItem<int>(
                      value: displayList.indexOf(dechet),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(dechet.sousType),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.only(right: 200.0),child: const Text("Poids du déchet" , style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,),)) ,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: NumberInputWidget(
                    controller: quantityController,
                    onNumberChanged: (int value) {
                      quantityController.text = value.toString();
                      print(quantityController.text);
                    },
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: onAjouterClicked,
                  child: const Text('Ajouter'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NumberInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(int) onNumberChanged;

  const NumberInputWidget({
    required this.controller,
    required this.onNumberChanged,
    Key? key,
  }) : super(key: key);

  @override
  _NumberInputWidgetState createState() => _NumberInputWidgetState();
}

class _NumberInputWidgetState extends State<NumberInputWidget> {
  int _value = 0;

  void _increment() {
    setState(() {
      _value++;
      widget.controller.text = _value.toString();
      widget.onNumberChanged(_value);
    });
  }

  void _decrement() {
    setState(() {
      if (_value > 0) {
        _value--;
        widget.controller.text = _value.toString();
        widget.onNumberChanged(_value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _value = int.tryParse(value) ?? 0;
                });
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                hintText: 'Quantité',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: _increment,
            icon: const Icon(Icons.arrow_drop_up),
          ),
          IconButton(
            onPressed: _decrement,
            icon: const Icon(Icons.arrow_drop_down),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}

class SelectedItemWidget extends StatelessWidget {
  final List<Map<Dechet, double>> selectedDechets;
  final Function(int) onRemove;

  const SelectedItemWidget({
    required this.selectedDechets,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Votre Dechets',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: selectedDechets.length,
            itemBuilder: (context, index) {
              final selectedDechet = selectedDechets[index];
              final dechet = selectedDechet.keys.first;
              final totalWeight = selectedDechet.values.first;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dechet Type: ${dechet.type}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Poids: ${totalWeight.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () {
                      onRemove(index);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
*/
