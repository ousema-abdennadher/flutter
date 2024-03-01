import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapComponent extends StatelessWidget {
  final LatLng? selectedLocation;
  final Function(LatLng) handleMapTap;

  MapComponent({required this.selectedLocation, required this.handleMapTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        Container(
          width: 360,
          height: 55,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF95F4CC),
                Color(0xFFFDFFFE),
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: const Text(
            'Map',
            style: TextStyle(
              fontFamily: 'KoHo',
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Color(0xFF037F73),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.lightGreen, // Set the border color here
                width: 1,
              ),
            ),
            height: 450,
            width: 360,
            child: GoogleMapWidget(
              selectedLocation: selectedLocation,
              handleMapTap: handleMapTap,
            ),
          ),
        ),

      ],
    );
  }
}


class GoogleMapWidget extends StatefulWidget {
  final LatLng? selectedLocation;
  final Function(LatLng) handleMapTap;

  GoogleMapWidget({required this.selectedLocation, required this.handleMapTap});

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(34.74003958350314, 10.759780571692039);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        onTap: widget.handleMapTap, // Use the handleMapTap from the widget parameter
        markers: widget.selectedLocation != null
            ? <Marker>{
          Marker(
            markerId: const MarkerId("selected_location"),
            position: widget.selectedLocation!,
          ),
        }
            : Set<Marker>(),
      );
  }
}

