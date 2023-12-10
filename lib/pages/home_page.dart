import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController _placeController = TextEditingController();
  List<String> _suggestions = [];

  Future<List<String>> _getAutocompleteResults(String input) async {
    final apiKey = 'AIzaSyDQLDWA9r8iLIruQ_xvtXORd8Xi2d6XD_Y';
    final apiUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    final response = await http.get(Uri.parse('$apiUrl?input=$input&key=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> predictions = data['predictions'];
      return predictions.map<String>((prediction) => prediction['description'] as String).toList();
    } else {
      throw Exception('Failed to fetch autocomplete results: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Autocomplete'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Signed in as ' + user.email!),
            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              color: Colors.amber,
              child: Text('sign out'),
            ),
            TextField(
              controller: _placeController,
              decoration: InputDecoration(labelText: 'Enter a Place'),
              onChanged: (value) async {
                if (value.length > 2) {
                  final suggestions = await _getAutocompleteResults(value);
                  setState(() {
                    _suggestions = suggestions;
                  });
                }
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index]),
                    onTap: () {
                      _placeController.text = _suggestions[index];
                      setState(() {
                        _suggestions = [];
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
