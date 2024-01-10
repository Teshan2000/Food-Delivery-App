import 'package:flutter/material.dart';

class FoodDeliveryApp extends StatefulWidget {
  const FoodDeliveryApp({super.key});

  @override
  _FoodDeliveryAppState createState() => _FoodDeliveryAppState();
}

class _FoodDeliveryAppState extends State<FoodDeliveryApp> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _foodList = [
    "Pizza",
    "Burger",
    "Hotdog",
    "Sandwich",
    "Taco",
    "Bun",
    "Bread",
  ];

  final List<String> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Delivery App"),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: onSearchTextChanged,
              decoration: InputDecoration(
                hintText: "Search for food...",
              ),
            ),
            SizedBox(height: 5),
            _buildSearchResults(),
          ],
        ),
      ),
    );
  }

  void onSearchTextChanged(String query) {
    _searchResults.clear();
    if (query.isEmpty) {
      setState(() {});
      return;
    }

    for (var food in _foodList) {
      if (food.toLowerCase().contains(query.toLowerCase())) {
        _searchResults.add(food);
      }
    }

    setState(() {});
  }

  Widget _buildSearchResults() {
    return Expanded(
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_searchResults[index]),
            contentPadding: EdgeInsets.symmetric(vertical: 0),
          );
        },
      ),
    );
  }
}
