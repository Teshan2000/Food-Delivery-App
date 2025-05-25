import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class DeliveryPage extends StatefulWidget {
  final LatLng agentLocation;
  final LatLng userLocation;

  const DeliveryPage({
    Key? key,
    required this.agentLocation,
    required this.userLocation,
  }) : super(key: key);

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  List<LatLng> routePoints = [];
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    fetchRoute();
  }

  Future<void> fetchRoute() async {
    final apiKey = '5b3ce3597851110001cf624804d4bc2113c54f67a423545ba6da57d2';
    final url = Uri.parse(
        'https://api.openrouteservice.org/v2/directions/driving-car/geojson');

    final body = {
      'coordinates': [
        [widget.agentLocation.longitude, widget.agentLocation.latitude],
        [widget.userLocation.longitude, widget.userLocation.latitude],
      ]
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': apiKey,
        'Content-Type': 'application/json',
      }, 
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final coordinates = data['features'][0]['geometry']['coordinates'];

      setState(() {
        routePoints = coordinates
            .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
            .toList();
      });
    } else {
      print("Route fetch failed: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Center(
          child: Text('Track the Order'),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delivery_dining,
                size: 30,
              ))
        ],        
      ),
      body: Container(
        child: Stack(
          children: [
            FlutterMap(
                options: MapOptions(
                  initialCenter: widget.agentLocation,
                  initialZoom: 16.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'com.yourcompany.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: widget.agentLocation,
                        width: 60,
                        height: 60,
                        child: Icon(Icons.delivery_dining,
                            size: 40, color: Colors.red),
                      ),
                      Marker(
                        point: widget.userLocation,
                        width: 60,
                        height: 60,
                        child: Icon(Icons.location_pin,
                            size: 40, color: Colors.blue),
                      )
                    ],
                  ),
                  if (routePoints.isNotEmpty)
                    PolylineLayer(polylines: [
                      Polyline(
                        points: routePoints,
                        strokeWidth: 5.0,
                        color: Colors.red,
                      )
                    ])
                ]
              ),
              
          ],
        ),
      ),
    );
  }
}
