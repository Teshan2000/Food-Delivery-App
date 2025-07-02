import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_delivery_app/components/button.dart';
import 'package:food_delivery_app/providers/alert_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:rating_dialog/rating_dialog.dart';

class DeliveryPage extends StatefulWidget {
  // final LatLng agentLocation;
  final LatLng userLocation;
  final String agentId;
  final String orderId;

  const DeliveryPage({
    Key? key,
    // required this.agentLocation,
    required this.userLocation,
    required this.agentId,
    required this.orderId,
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
  AlertService alertService = AlertService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? locationSubscription;
  int _currentStep = 0;
  bool _isDelivered = false;

  List<Step> get _deliverySteps => [
        Step(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Order placed", style: TextStyle(fontWeight: FontWeight.bold,)),
              Icon(
                Icons.fastfood,
                color: Colors.amber,
              )
            ],
          ),
          subtitle: const Text("10 mins ago"),
          content: const Text("Your order has been placed"),
          isActive: _currentStep >= 0,
          stepStyle: StepStyle(
            color: Colors.amber,
            connectorColor: Colors.amber,
          ),
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Order prepared", style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(
                Icons.shopping_bag,
                color: Colors.amber,
              )
            ],
          ),
          subtitle: const Text("2 mins ago"),
          content: const Text("Your order is preparing"),
          isActive: _currentStep >= 1,
          stepStyle: StepStyle(
            color: Colors.amber,
            connectorColor: Colors.amber,
          ),
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Order delivered", style: TextStyle(fontWeight: FontWeight.bold,)),
              Icon(
                Icons.delivery_dining,
                color: Colors.amber, size: 28,
              )
            ],
          ),
          subtitle: Text(_isDelivered
              ? "Order Delivered in 20 mins"
              : "Estimated Time: 20 mins"),
          content: Text(_isDelivered
              ? "Your order has been delivered"
              : "Your order is delivering"),
          isActive: _currentStep >= 2,
          stepStyle: StepStyle(
            color: Colors.amber,
            connectorColor: Colors.amber,
          ),
          state: _isDelivered ? StepState.complete : StepState.indexed,
        ),
      ];

  @override
  void initState() {
    super.initState();
    listenToAgentLocation();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    _animationTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchRoute(LatLng start, LatLng end) async {
    final apiKey = '5b3ce3597851110001cf624804d4bc2113c54f67a423545ba6da57d2';
    final url = Uri.parse(
        'https://api.openrouteservice.org/v2/directions/foot-walking/geojson');

    final body = {
      'coordinates': [
        [start.longitude, start.latitude],
        [end.longitude, end.latitude],
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
    locationSubscription = _firestore
        .collection('agents')
        .doc(widget.agentId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        final geoPoint = data['location'];
        final newLocation = LatLng(geoPoint.latitude, geoPoint.longitude);

        if (agentLocation == null || agentLocation != newLocation) {
          setState(() {
            agentLocation = newLocation;
          });
          fetchRoute(newLocation, widget.userLocation);
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

  Future<void> simulateAgentAlongRoute(
      List<LatLng> routePoints, String agentId) async {
    const delay = Duration(milliseconds: 500);

    for (final point in routePoints) {
      await FirebaseFirestore.instance
          .collection('agents')
          .doc(agentId)
          .update({
        'location': GeoPoint(point.latitude, point.longitude),
      });
      await Future.delayed(delay);
    }
    // This runs after the agent has reached the destination
    setState(() {
      _isDelivered = true;
      _currentStep = 2; // Assuming last step index is 2 (0, 1, 2)
    });

    // ✅ Update Firestore order status to 'Delivered'
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('orders')
        .doc(widget.orderId)
        .update({
      'status': 'Delivered',
    }).then((_) {
      alertService.showToast(
          context: context, text: 'Food Delivered successfully!', icon: Icons.info);
    }).catchError((error) {
      alertService.showToast(context: context, text: 'Food Delivering Failed!', icon: Icons.warning);
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
            agentLocation == null
                ? const Center(child: CircularProgressIndicator())
                : FlutterMap(
                    options: MapOptions(
                      initialCenter:
                          LatLng(6.8364853623103565, 79.96910687993515),
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
                              point: agentLocation!,
                              width: 60,
                              height: 60,
                              child: !_isDelivered
                                  ? Icon(Icons.delivery_dining,
                                      size: 40, color: Colors.red)
                                  : Icon(Icons.home,
                                      size: 2, color: Colors.black),
                            ),
                            Marker(
                              point: widget.userLocation,
                              width: 60,
                              height: 60,
                              child: AnimatedUserMarker(),
                              // child: AnimatedUserMarker(),
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
              // left: 0,
              // right: 0,
              bottom: 0,
              // child: DraggableScrollableSheet(
              //   builder: (BuildContext context,
              //       ScrollController scrollController) {
              child: SingleChildScrollView(
                child: Container(
                  height: height * 0.53,
                  width: width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      shape: BoxShape.rectangle,
                      color: Colors.amber),
                  child: Column(
                    children: [
                      Container(
                        decoration: ShapeDecoration(
                          color: Colors.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15))),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 5, top: 15, bottom: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Order Delivery",
                                      style: TextStyle(
                                        fontSize: 19,
                                      ),
                                    ),
                                    const Text(
                                      "Estimated Time: 30 mins",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      simulateAgentAlongRoute(
                                          routePoints, widget.agentId);
                                    },
                                    icon: Icon(Icons.refresh))
                              ]),
                        ),
                      ),                      
                      Container(
                        height: height * 0.43,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Stepper(
                                currentStep: _currentStep,
                                steps: _deliverySteps,
                                connectorColor:
                                    WidgetStatePropertyAll(Colors.amber),
                                connectorThickness: 3.0,
                                type: StepperType.vertical,
                                physics: const ClampingScrollPhysics(),
                                onStepTapped: (step) =>
                                    setState(() => _currentStep = step),
                                controlsBuilder: (BuildContext context,
                                    ControlsDetails details) {
                                  return const SizedBox.shrink();
                                }),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Button(
                                title: 'Complete Order',
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return RatingDialog(
                                            initialRating: 1.0,
                                            title: const Text(
                                              'Rate the Delivery',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            message: const Text(
                                              'Please help us to rate our Delivery Agent',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            image:
                                                Image.asset('Assets/icon.png'),
                                            submitButtonText: 'Submit',
                                            submitButtonTextStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17),
                                            commentHint: 'Add Your Review',
                                            onSubmitted: (response) async {
                                              alertService.showToast(
                                                context: context, text: 'Your Review submitted!', 
                                                icon: Icons.info);
                                            });
                                      });
                                },
                                disable: false,
                                width: double.infinity,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedUserMarker extends StatefulWidget {
  @override
  _AnimatedUserMarkerState createState() => _AnimatedUserMarkerState();
}

class _AnimatedUserMarkerState extends State<AnimatedUserMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(_controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Icon(Icons.location_on, color: Colors.blue, size: 36),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
