import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modernlogintute/components/googleMaps.dart';
import '../components/MyAppBar.dart';
import '../components/stepIndecator.dart';
import '../model/dechet.dart';
import '../model/user.dart';
import 'TimeDispo.dart';


class MapSample extends StatefulWidget {
  late List<Map<Dechet,int>> colis ;
  late User user ;
   MapSample({super.key, required this.colis, required this.user});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final locationNameController = TextEditingController();

  LatLng? selectedLocation;

  void handleMapTap(LatLng tappedPoint) {
    setState(() {
      selectedLocation = tappedPoint;
    });
    print(selectedLocation);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(leading: Image.asset('lib/images/logo.png'),),
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
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start, // Align children to start (left to right)
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 15,),
                  const StepIndicator(currentStep: 1),
                  const SizedBox(height: 15,),
                  MapComponent(
                      selectedLocation: selectedLocation,
                      handleMapTap: handleMapTap),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: (){
                      print(selectedLocation);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimeDispo(user : widget.user ,colis:widget.colis, latlang: selectedLocation ,),
                        ),
                      );
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("SUIVANT",style: TextStyle(
                            fontFamily: 'InterTight',
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: 3,
                          ),),
                          Icon(
                            Icons.add_location ,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),

                    ),
                  const SizedBox(height: 85,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

