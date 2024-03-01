import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
//import 'package:modernlogintute/pages/addDemande.dart';
import 'package:modernlogintute/pages/test.dart';
import '../components/MyAppBar.dart';
import '../components/inviteésignup.dart';
import '../helpers/helpersVariables.dart';
import '../model/dechet.dart';
import '../model/colis.dart';
import '../model/request.dart';
import '../model/user.dart';



class DemandPage extends StatefulWidget {
  final User user;
  const DemandPage({required this.user, Key? key}) : super(key: key);
  @override
  _DemandPageState createState() => _DemandPageState();
}

class _DemandPageState extends State<DemandPage> {

  late List<Request> req = [];

  @override
  void initState() {
    super.initState();
    fetchRequests(); // Fetch requests when the widget is initialized
  }


  Future<void> fetchRequests() async {
    try {
      req = await getReqUserByID(widget.user.id);
      //print(req);
    } catch (e) {
      print('Error fetching requests: $e');
      req = []; // Set an empty list in case of an error
    }
    setState(() {}); // Update the widget state to rebuild with the fetched requests
  }

  Future<List<Request>> getReqUserByID(int? userId) async {
    final List<Request> requests = [];
    final url = Uri.parse('${ENV_variables.API_PATH}/request/get_by_user_id.php?user_id=$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseBody = response.body;
        //print(responseBody) ;
        if (responseBody.isNotEmpty) {
          final requestData = json.decode(responseBody);

          if (requestData != null && requestData is List) {
            for (var requestMap in requestData) {
              requests.add(
                Request(
                  id: requestMap['id'],
                  clientId: requestMap['id_client'],
                  livreurId: requestMap['id_livreur'],
                  date: DateTime.parse(requestMap['date']),
                  point: requestMap['point'].toDouble(),
                  status: requestMap['status'] == 1,
                  location: requestMap['location'],
                ),
              );
            }

          }
          else {
            print('Invalid response data format.');
          }
        } else {
          print('Response body is empty.');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Errorr: $e');
    }

    return requests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(leading: Image.asset('lib/images/logo.png'),showBackArrow: false,),
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
            (widget.user.id != -1) ?
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "DEMANDE",
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

                  const SizedBox(height: 20),
                  Expanded(
                    child: req.isNotEmpty
                        ? ListView.builder(
                      itemCount: req.length,
                      itemBuilder: (context, index) {
                        return DemandeWidget(request: req[index]);
                      },
                    )
                        : const  Center(
                      child: Text(
                        'No requests found.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ): const Center(child: GoToLogIn())
          ],
        ),
      ),
      floatingActionButton: AddButton(
        circleSize: 65,
        iconSize: 42,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>   Test(user : widget.user),
            ),
          ) ;
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

    );
  }
}

class AddButton extends StatelessWidget {
  final double circleSize;
  final double iconSize;
  final VoidCallback onPressed;

  const AddButton({
    required this.circleSize,
    required this.iconSize,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      color: Colors.white,
      elevation: 4, // Add elevation for shadow
      shadowColor: Colors.grey.withOpacity(0.5), // Specify shadow color and opacity

      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(4, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: onPressed,
          child: Container(
            width: circleSize,
            height: circleSize,
            child: Icon(
              Icons.add_box_rounded,
              color: Colors.grey,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}


class DemandeWidget extends StatefulWidget {
  final Request request;
  const DemandeWidget({
    required this.request,
    Key? key,
  }) : super(key: key);

  @override
  State<DemandeWidget> createState() => _DemandeWidgetState();
}

class _DemandeWidgetState extends State<DemandeWidget> {

  late int? requestId ;
  late List<Colis> colis;
  late double poidsTotale = 0.0 ;
  late List<Dechet> dechetList =[] ;

  Future<List<Colis>> getColis(int? requestId) async {
    final List<Colis> listColis = [];
    final url = Uri.parse('${ENV_variables.API_PATH}/colis/get_req.php?id_request=$requestId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = response.body;

        if (responseBody.isNotEmpty) {
          final colisData = json.decode(responseBody);
          //print(colisData) ;
          if (colisData != null && colisData is List) {
            for (var i = 0; i < colisData.length; i++) {
              final colisMap = colisData[i];
              //print(colisMap) ;
              final colis = Colis(
                id: colisMap['id'],
                idDechet: colisMap['id_dechet'],
                idReq: colisMap['id_request'],
                poidsEstimee: colisMap['poids_estimee'].toDouble(),
                poidsReel: (colisMap['poids_reel']??0).toDouble(),
              );
              // Fetch the dechet for this colis
              final dechet = await getDechet(colis.idDechet);

              // Set the dechet property of the colis
               for (var elements in dechet)   {
                colis.dechet = elements;
              }
              listColis.add(colis);

            }
            //
            //print(listColis) ;
          }
          else {
            print('Invalid response data format.' + response.statusCode.toString());
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
    return listColis;
  }

  double calculateTotalPoids(List<Colis> colisList) {
    double totalPoidsReel = colisList.fold(0.0, (double accumulator, Colis colis) {
      return accumulator + colis.poidsEstimee!.toDouble();
    });
    return totalPoidsReel;
  }

  Future<List<Dechet>> getDechet(int idDechet) async {
    final response = await http.get(
      Uri.parse('${ENV_variables.API_PATH}/dechet/get_id.php?id-dechet=$idDechet'),
    );

    if (response.statusCode == 200) {
      final Map<dynamic, dynamic> data = json.decode(response.body);

      List<Dechet> dechets = [];

      // Iterate through the parsed data and create Dechet instances
      for (var dechetData in data['dechet']) {
        String generalTypeName = dechetData['general_type_name'];
        for (var typeData in dechetData['types']) {
          int typeId = typeData['type_id'];
          String typeName = typeData['type_name'];
          double pointsPerKg = typeData['point_per_kg'].toDouble();
          List<DechetObject> objects = [];

          for (var objectData in typeData['objects']) {
            int objectId = objectData['object_id'];
            String objectName = objectData['object_name'];
            double poids = double.parse(objectData['poids']);

            objects.add(DechetObject(
                id: objectId, name: objectName, poids: poids));
          }
          var dechet = Dechet(
            id: typeId,
            generalTypeName: generalTypeName,
            name: typeName,
            pointsPerKg: pointsPerKg,
            objects: objects,
          ) ;
          dechets.add(dechet);
        }
      }

      return dechets;
    } else {
      throw Exception('Failed to load dechet list');
    }
  }

  Future<List<Dechet>> getDechetsForColis(List<Colis> colisList) async {
    final List<Dechet> dechets = [];
    for (final colis in colisList) {
      final dechet = await getDechet(colis.idDechet);
      for (var element in dechet) {
        dechets.add(element);
      }
    }
    return dechets;
  }

  @override
  void initState() {
    super.initState();
    requestId = widget.request.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    //print(requestId.toString) ;
    colis = await getColis(requestId);
    //print("colis list  = " + colis.toString() );
    colis.isNotEmpty ? poidsTotale =  calculateTotalPoids(colis)  : poidsTotale = 0.0 ;
    dechetList = await getDechetsForColis(colis);
    print(dechetList);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient:  LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Colors.white.withOpacity(0.5),
              const Color(0xFF2FDDAE).withOpacity(0.3), // First color - #80edc7
              // Second color - #4ca2d2
            ],
          ),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(45), // Add border radius
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Theme(
            data: Theme.of(context).copyWith(
              textTheme: Theme.of(context).textTheme.copyWith(
                titleMedium: const TextStyle(color: Colors.white),
              ),
            ),
            child: ExpansionTile(
              title: ListTile(
                leading: const Icon(Icons.recycling, size: 50),
                title: Text('Poids: $poidsTotale kg', style: const  TextStyle(
                  fontFamily: "KoHo", // Replace with your font family
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 2,
                )),
                subtitle: Text('Crédits: ${widget.request.point ?? ""}', style: const TextStyle(
                  fontFamily: "KoHo", // Replace with your font family
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 2,
                )),
                trailing: Icon(
                  widget.request.status == true ? Icons.check_circle_outline_rounded : Icons.timelapse_rounded,
                  size: 20,
                ),
                textColor: Colors.white,
                iconColor: Colors.white,
              ),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dechetList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 30,),
                            const CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 4,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Type: ${dechetList[index].name}',
                              textAlign: TextAlign.center,
                              style: const  TextStyle(
                                fontFamily: "InterTight", // Replace with your font family
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
              onExpansionChanged: (expanded) {
                print('Tile expanded: $expanded');
              },
            ),
          ),
        ),
      ),
    );
  }


}
