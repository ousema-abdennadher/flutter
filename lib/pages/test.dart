import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modernlogintute/components/MyAppBar.dart';
import 'package:http/http.dart' as http;
import '../components/stepIndecator.dart';
import '../helpers/helpersVariables.dart';
import '../model/dechet.dart';
import '../model/user.dart';
import 'locations.dart';

class Test extends StatefulWidget {
  User user ;
  Test({super.key , required this.user});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late List<Dechet> dechets =[] ;
  late List<CustomInputWidget> widgets =[] ;

  @override
  void initState() {
    fetchData(); // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(leading: Image.asset('lib/images/logo.png')),
      backgroundColor: Colors.transparent,
      body: Center(
        child: FutureBuilder<List<Dechet>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              dechets = snapshot.data!;
              widgets = dechets.map((dechet) => CustomInputWidget(mapDechet: {dechet:0},)).toList();

              return Center(
                child: Container(
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15,),
                          const StepIndicator(currentStep: 0),
                          const SizedBox(height: 15,),
                          Expanded(
                            child: ListView.builder(
                              itemCount: widgets.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: widgets[index] ,
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 30,),
                                CustomButton(onTap: (){
                                  print('button tapped');
                                  print(extractColis() );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapSample(colis: extractColis() ,user : widget.user),
                                    ),
                                  );
                                  },)
                              ],
                            ),
                          ),
                          const SizedBox(height: 30,)
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Future<List<Dechet>> fetchData() async {
    final response = await http.get(
      Uri.parse('${ENV_variables.API_PATH}/dechet/test.php'),
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
          widgets.add(CustomInputWidget(mapDechet: {dechet:0},)) ;
        }
      }

      return dechets;
    } else {
      throw Exception('Failed to load dechet list');
    }
  }

  List<Map<Dechet,int>> extractColis(){
    /*for (var el in widgets){
      print(el.mapDechet);
    }*/
    List<CustomInputWidget> filteredWidgets ;
    List<Map<Dechet,int>> filteredMap = [];
    filteredWidgets = widgets.where((element) => (element.mapDechet.values.first != 0)).toList() ;
    for (var element in filteredWidgets) {
      filteredMap.add(element.mapDechet) ;
    }
    return filteredMap ;
  }
}
class CustomButton extends StatelessWidget {
  late void Function() onTap ;

  CustomButton({super.key,required this.onTap}) ;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 50,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
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
            width: 2,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'START',
                style: TextStyle(
                  fontFamily: 'InterTight',
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  letterSpacing: 3,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CustomInputWidget extends StatefulWidget {
  Map<Dechet,int> _mapDechet ;

  CustomInputWidget({super.key, required Map<Dechet,int>mapDechet,}):_mapDechet = mapDechet;
  // Getter for mapDechet
  Map<Dechet, int> get mapDechet => _mapDechet;

  // Setter for mapDechet
  set mapDechet(Map<Dechet, int> newMapDechet) {
    _mapDechet = newMapDechet;
  }

  @override
  _CustomInputWidgetState createState() => _CustomInputWidgetState();
}

class _CustomInputWidgetState extends State<CustomInputWidget> {
  late int value;
  late Dechet dechet ;
  @override
  void initState() {
    super.initState();
    value = widget._mapDechet.values.first;
    dechet = widget._mapDechet.keys.first;
  }

  void _increment() {
    setState(() {
      value++;
      widget._mapDechet[dechet] = value ;
    });
  }

  void _decrement() {
    setState(() {
      if (value > 0) {
        value--;
        widget._mapDechet[dechet] = value ;
      }
    });
  }
  String _getImageAsset(String dechetName) {
    switch (dechetName) {
      case "Plastique PET":
        return 'lib/images/plastiquePET.png';
      case "Plastique PEHD":
        return 'lib/images/plastiquePEHD.png';
      case "Papier carton":
        return 'lib/images/carton.png';
      case "Inox":
      case "Aluminium":
        return 'lib/images/metaux.png';
      default:
        return 'lib/images/verre.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color:  Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(_getImageAsset(dechet.name), width: 42, height: 42), // Replace with your image
          const VerticalDivider(color: Colors.white , thickness: 2,),
      Expanded(
        child: Text(
          dechet.name,
          style: const TextStyle(
              color: Color(0xFF037F73),
              fontFamily: "KoHo",
              fontWeight: FontWeight.w500,
              fontSize: 20),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFF41A599),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Text(
              "Qté",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "InterTight",
                  fontWeight: FontWeight.w500,
                  fontSize: 18
              ),
            ),
            IconButton(
              onPressed: _decrement,
              icon: const Icon(Icons.arrow_downward, color: Colors.white),
            ),
            Text(
              value.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            IconButton(
              onPressed: _increment,
              icon: const Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ],
        ),
      )],
      ),
    );
  }
}

