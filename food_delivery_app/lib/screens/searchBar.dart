import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String searchText = '';
  final TextEditingController _controller =
      TextEditingController(text: 'Initial Text');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search Something Here',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      searchText = '';
                    });
                  },
                ),
              ),
              onChanged: (value) {
                debugPrint('value on Change');
                setState(() {
                  searchText = value;
                });
              },
            ),
            Text(
              searchText,
              style: const TextStyle(fontSize: 24),
            )
          ],
        ),
      ),
    );
  }
}
