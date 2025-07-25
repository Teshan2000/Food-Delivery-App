import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/providers/alert_service.dart';

class Searchbar extends StatefulWidget {
  final Function(List<Map<String, dynamic>>, bool) onSearchResultsUpdated;
  
  const Searchbar({Key? key, required this.onSearchResultsUpdated}) : super(key: key);

  @override
  _SearchbarState createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  AlertService alertService = AlertService();
  final TextEditingController _searchController = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _isTyping = _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchSearchResults(String query) async {
    if (query.isEmpty) {
      widget.onSearchResultsUpdated([], false);
      alertService.showToast(context: context, text: 'Food Not Found!', icon: Icons.warning);
      return;
    }
    widget.onSearchResultsUpdated([], true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('foods')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      List<Map<String, dynamic>> results = snapshot.docs.map((doc) {
        return {
          "food_id": doc.id,
          "name": doc['name'],
          "image": doc['image'],
          "price": doc['price'],
        };
      }).toList();

      widget.onSearchResultsUpdated(results, false);
    } catch (e) {
      alertService.showToast(context: context, text: 'Food Seraching Failed!', icon: Icons.warning);
      print('Error fetching search results: $e');
      widget.onSearchResultsUpdated([], false);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    widget.onSearchResultsUpdated([], false);
    setState(() {
      _isTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
          child: TextField(
            controller: _searchController,
            onChanged: (query) => _fetchSearchResults(query),
            decoration: InputDecoration(
              hintText: "Search Foods",
              hintStyle: TextStyle(fontWeight: FontWeight.w700,),
              fillColor: Colors.white,
              filled: true,
              suffixIcon: _isTyping
                  ? IconButton(onPressed: _clearSearch, icon: Icon(Icons.close))
                  : IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.amber,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.amber,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}