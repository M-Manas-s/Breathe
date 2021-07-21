import 'dart:async';

import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Login.dart';

class MapView extends StatefulWidget {
  
  static String id = 'MapViewView';
  
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  bool infovis = false;
  String Vname = "";
  String Vpno = "";

  void assignMarker(){
    setState(() {

    });
  }


  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapViewCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex : 2,
            child: Container(
              child: GoogleMap(
                onMapCreated: _onMapViewCreated,
                markers: {
                  Marker(markerId: MarkerId('m1'),
                      onTap: () {
                        setState(() {
                            Navigator.pushNamed(context, Login.id);
                        });
                      },
                    position: LatLng(45.621563, -122.677433),
                    infoWindow: InfoWindow(
                      title: 'Oxygen Vendor1',
                      snippet: 'Available : 1',
                    ),
                  )
                },
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
              ),
            ),
          ),
          infovis ? Expanded(child: Container(
            child: Column(
              children: [
                Text(Vname),
                Text(Vpno),
              ],
            ),
          ), flex : 1)
          : Container(),
        ],
      ),
    );
  }
}
