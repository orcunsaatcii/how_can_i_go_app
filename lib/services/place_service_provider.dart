import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:how_can_i_go_app/constants/constants.dart';
import 'package:http/http.dart' as http;

class PlacesNotifier extends StateNotifier<List<Map<String, String>>> {
  PlacesNotifier() : super([]);

  Future<void> fetchPlaces(String input) async {
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';
      final List<Map<String, String>> places = [];

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        final predictions = decodedData['predictions'];

        for (var prediction in predictions) {
          places.add(
            {
              'description': prediction['description'],
              'place_id': prediction['place_id'],
            },
          );
        }
      } else {
        throw Exception('Failed to load places');
      }
      state = places;
    } catch (e) {
      print('Error fetching data');
    }
  }

  void resetPlaces() {
    state = [];
  }
}

final placesProvider =
    StateNotifierProvider<PlacesNotifier, List<Map<String, String>>>(
  (ref) => PlacesNotifier(),
);
