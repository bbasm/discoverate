import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  List<Map<String, dynamic>> _similarPlaces = [];
  bool isLoading = false;
  bool searched = false;

  Future<List<String>> _getAutocompleteResults(String input) async {
    final apiKey = 'AIzaSyDQLDWA9r8iLIruQ_xvtXORd8Xi2d6XD_Y';
    final apiUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    final response =
        await http.get(Uri.parse('$apiUrl?input=$input&key=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> predictions = data['predictions'];
      return predictions
          .map<String>((prediction) => prediction['description'] as String)
          .toList();
    } else {
      throw Exception(
          'Failed to fetch autocomplete results: ${response.statusCode}');
    }
  }

  Future<void> _searchSimilarPlaces() async {
    setState(() {
      isLoading = true;
      searched = true;
    });

    final apiKey = 'AIzaSyDQLDWA9r8iLIruQ_xvtXORd8Xi2d6XD_Y';
    final place = _placeController.text;
    final apiUrl =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json';

    final response = await http.get(Uri.parse(
        '$apiUrl?input=$place&inputtype=textquery&fields=name,geometry,types&key=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final location = data['candidates'][0]['geometry']['location'];
      final latitude = location['lat'];
      final longitude = location['lng'];
      final placeTypes = data['candidates'][0]['types'] as List<dynamic>;

      final typeQueries = placeTypes.map((type) => 'type=$type').join('&');
      final nearbyPlacesUrl =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=1500&$typeQueries&key=$apiKey';

      final nearbyResponse = await http.get(Uri.parse(nearbyPlacesUrl));

      if (nearbyResponse.statusCode == 200) {
        final Map<String, dynamic> nearbyData =
            json.decode(nearbyResponse.body);
        final List<dynamic> places = nearbyData['results'];

        List<Map<String, dynamic>> similarPlaces = [];
        for (var place in places) {
          final placeName = place['name'] as String;
          final placeRating = place['rating'] ?? 0.0;

          similarPlaces.add({
            'name': placeName,
            'rating': placeRating,
          });
        }

        setState(() {
          _similarPlaces = similarPlaces;
        });
      } else {
        throw Exception(
            'Failed to fetch similar places: ${nearbyResponse.statusCode}');
      }
    } else {
      throw Exception('Failed to fetch place details: ${response.statusCode}');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 249, 235),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Signed in as ' + user.email!),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 10),
                  child: Text(
                    "Please add a recent place",
                    style: GoogleFonts.raleway(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 90),
                  child: IconButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      icon: Icon(
                        Icons.logout,
                        size: 30,
                      )),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.only(top: 15, left: 20, right: 20),
              child: TextFormField(
                controller: _placeController,
                onChanged: (value) async {
                  if (value.length > 2) {
                    final suggestions = await _getAutocompleteResults(value);
                    setState(() {
                      _suggestions = suggestions;
                    });
                  }
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      //color: Color(0xFFF1F4F8),
                      color: Colors.grey,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Enter a place',
                  contentPadding: EdgeInsetsDirectional.fromSTEB(25, 15, 0, 15),
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15, left: 20, right: 20),
              child: GestureDetector(
                onTap: () {
                  _searchSimilarPlaces();
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 76, 121, 9),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Search',
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            if (!searched)
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

            if (searched)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  height: 580,
                  child: ListView.builder(
                    itemCount: _similarPlaces.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_similarPlaces[index]['name']),
                        subtitle:
                            Text('Rating: ${_similarPlaces[index]['rating']}'),
                        // Add onTap functionality if needed for similar places
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
