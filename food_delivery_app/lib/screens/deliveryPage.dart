import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class DeliveryPage extends StatefulWidget {
  // final LatLng agentLocation;
  final LatLng userLocation;
  final String agentDocId;

  const DeliveryPage({
    Key? key,
    // required this.agentLocation,
    required this.userLocation,
    required this.agentDocId,
  }) : super(key: key);

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  LatLng? agentLocation;
  List<LatLng> routePoints = [];
  LatLng? oldLocation;
  LatLngTween? _latLngTween;
  Timer? _animationTimer;
  int _animationStep = 0;
  static const int totalSteps = 30;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? locationSubscription;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    fetchRoute();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    _animationTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchRoute() async {
    final apiKey = '5b3ce3597851110001cf624804d4bc2113c54f67a423545ba6da57d2';
    final url = Uri.parse(
        'https://api.openrouteservice.org/v2/directions/driving-car/geojson');

    final body = {
      'coordinates': [
        [agentLocation?.longitude, agentLocation?.latitude],
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

  void listenToAgentLocation() {
    locationSubscription = _firestore.collection('agents').doc(widget.agentDocId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        final newLocation = LatLng(data['lat'], data['lat']);

        if (agentLocation == null) {
          setState(() {
            agentLocation = newLocation;
          });
          fetchRoute(a, widget.userLocation);
        } else if (agentLocation != newLocation) {
          animateMarker(newLocation);
          fetchRoute(newLocation, widget.userLocation);
        }
      }
    });
  }

  void animateMarker(LatLng newLocation) {
    oldLocation = agentLocation;
    _latLngTween = LatLngTween(begin: oldLocation!, end: newLocation);
    _animationStep = 0;

    _animationTimer?.cancel();
    _animationTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_animationStep >= totalSteps) {
        agentLocation = newLocation;
        timer.cancel();
        return;
      }

      final t = _animationStep / totalSteps;
      final animated = _latLngTween!.lerp(t);
      setState(() {
        agentLocation = animated;
      });
      _animationStep++;
    });
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 10),
          child: SizedBox(),
        ),
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
                ]),
            Positioned(
                // top: 50,
                left: 0,
                right: 0,
                bottom: 0,
                child: DraggableScrollableSheet(
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return SingleChildScrollView(
                      child: Container(
                        height: height * 0.35,
                        width: width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                            shape: BoxShape.rectangle,
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text(
                                      "Order Summary",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => const Cart(),
                                        //   ),
                                        // );
                                      },
                                      child: const Text(
                                        "View Order",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                  ]),
                              // const SizedBox(height: 20),
                              Stepper(
                                currentStep: _currentStep,
                                onStepTapped: (int index) {
                                  setState(() {
                                    _currentStep = index;
                                  });
                                },
                                controlsBuilder: (context, _) =>
                                    const SizedBox(),
                                steps: const [
                                  Step(
                                      title: Text("Order preparing"),
                                      content: Text(
                                          "Your order has been placed prepared!"),
                                      isActive: true,
                                      state: StepState.complete),
                                  Step(
                                    title: Text("Order delivering"),
                                    content: Text(
                                        "Your order has been placed prepared!"),
                                    isActive: false,
                                  ),
                                  Step(
                                    title: Text("Order arrived"),
                                    content: Text(
                                        "Your order has been placed prepared!"),
                                    isActive: false,
                                  ),
                                ],
                                type: StepperType.vertical,
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: <Widget>[
                              //     const Text(
                              //       "Delivery Status",
                              //       style: TextStyle(
                              //         fontSize: 18,
                              //       ),
                              //     ),
                              //   ]),
                              // const SizedBox(height: 20),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: <Widget>[
                              //     const Text(
                              //       "Delivery Location",
                              //       style: TextStyle(
                              //         fontSize: 18,
                              //       ),
                              //     ),
                              //   ]),
                              //   const SizedBox(height: 20),
                              Container(
                                decoration: ShapeDecoration(
                                  color: Colors.amber,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: ShapeDecoration(
                                        color: Colors.amber,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // StreamBuilder<QuerySnapshot>(
                                          //     stream: _firestore
                                          //         .collection('users')
                                          //         .doc(user?.uid)
                                          //         .collection('shippingDetails')
                                          //         .snapshots(),
                                          //     builder: (context, snapshot) {
                                          //       if (!snapshot.hasData) {
                                          //         return Text(
                                          //             "No Shipping Details added!");
                                          //       }
                                          //       var addressData = snapshot.data!.docs;
                                          //       return ListView.builder(
                                          //           shrinkWrap: true,
                                          //           itemCount: addressData.length,
                                          //           itemBuilder: (context, index) {
                                          //             var data = addressData[index];
                                          //             return ShippingDetails(
                                          //               address1:
                                          //                   "${data['address']}, ${data['city']}",
                                          //               address2:
                                          //                   "${data['state']}, ${data['country']}, ${data['zipCode']}",
                                          //             );
                                          //           });
                                          //     }),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: <Widget>[
                              //       const Text(
                              //         "Delivery Method",
                              //         style: TextStyle(
                              //           fontSize: 18,
                              //         ),
                              //       ),
                              //     ]),
                              // const SizedBox(height: 20),
                              // Card(
                              //   elevation: 5,
                              //   color: Colors.amber,
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(15),
                              //   ),
                              //   child: Row(children: [
                              //     Padding(
                              //       padding: const EdgeInsets.symmetric(
                              //           horizontal: 5, vertical: 10),
                              //       child: Row(
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.center,
                              //           children: <Widget>[
                              //             const SizedBox(width: 20),
                              //             Image.asset(
                              //               "Assets/pick me foods.jpg",
                              //               width: 80,
                              //               height: 80,
                              //             ),
                              //             const SizedBox(width: 30),
                              //             Column(
                              //                 mainAxisAlignment:
                              //                     MainAxisAlignment.start,
                              //                 crossAxisAlignment:
                              //                     CrossAxisAlignment.start,
                              //                 children: <Widget>[
                              //                   Text(
                              //                     "Pick Me Foods",
                              //                     style: const TextStyle(
                              //                         fontSize: 18,
                              //                         color: Colors.white),
                              //                   ),
                              //                   Text(
                              //                     "Rs. 50.00",
                              //                     style: const TextStyle(
                              //                         fontSize: 18,
                              //                         color: Colors.white),
                              //                   )
                              //                 ]),
                              //             const SizedBox(width: 25),
                              //             Column(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.end,
                              //               children: [
                              //                 IconButton(
                              //                     onPressed: () async {},
                              //                     icon: Icon(
                              //                       Icons.favorite,
                              //                       color: Colors.red,
                              //                     ))
                              //               ],
                              //             )
                              //           ]),
                              //     ),
                              //   ]),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
