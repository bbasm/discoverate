import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class PlaceAutocomplete extends StatefulWidget {
  @override
  _PlaceAutocompleteState createState() => _PlaceAutocompleteState();
}

class _PlaceAutocompleteState extends State<PlaceAutocomplete> {
  TextEditingController _placeController = TextEditingController();
  List<String> _suggestions = [];

  String getFormattedDate() {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
    return formattedDate;
  }

  Future<String> getUserLocation() async {
    // Check and request location permission if needed
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return 'Location permission denied';
      }
    }

    // Get the user's position (latitude and longitude)
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Format user's location as 'latitude,longitude'
    return '${position.latitude},${position.longitude}';
  }

  Future<List<String>> _getPlaces(String pattern) async {
    final String clientId = '0BFFSDAYNOCBCN2USHQDNFTEYYHJDIHC0S1NGR50JRCEDTQ1';
    final String clientSecret =
        'LGQH21IJG1PLCOX5G2MDDKOXZMTWECHKOKJQGO15L0NCETRP';
    final String apiUrl =
        'https://api.foursquare.com/v2/venues/suggestcompletion';

    // Construct parameters for the API request
    final Map<String, String> params = {
      'client_id': clientId,
      'client_secret': clientSecret,
      'v': getFormattedDate(), // Replace with today's date (format: YYYYMMDD)
      'll': await getUserLocation(), // Replace with user's location
      'query': pattern,
    };

    final response =
        await http.get(Uri.parse('$apiUrl?${_encodeParams(params)}'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> places = data['response']['minivenues'];
      return places.map<String>((place) => place['name'] as String).toList();
    } else {
      throw Exception('Failed to fetch places');
    }
  }

  String _encodeParams(Map<String, String> params) {
    return params.entries.map((e) => '${e.key}=${e.value}').join('&');
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
            TextField(
              controller: _placeController,
              decoration: InputDecoration(labelText: 'Enter a Place'),
              onChanged: (value) async {
                if (value.length > 2) {
                  final suggestions = await _getPlaces(value);
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
