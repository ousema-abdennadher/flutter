/*
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../components/googleMaps.dart';
import '../components/my_button.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {

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
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MapComponent(
              selectedLocation: selectedLocation,
              handleMapTap: handleMapTap,
            ),
            MyButton(
              innerText: 'términer',
              onTap: (){},
            )
          ],
        ),
      ),
    );
  }
}
*/
