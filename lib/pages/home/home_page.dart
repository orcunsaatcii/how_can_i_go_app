import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:how_can_i_go_app/constants/constants.dart';
import 'package:how_can_i_go_app/pages/map/page/map_page.dart';
import 'package:how_can_i_go_app/models/target_place.dart';
import 'package:how_can_i_go_app/services/place_service_provider.dart';
import 'package:http/http.dart' as http;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final textController = TextEditingController();
  String? selectedPlaceId;
  TargetPlace? targetPlace;

  List<dynamic> places = [];

  Future<void> destinationLocationSearchManually() async {
    String input = textController.text;
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&fields=formatted_address,name,geometry&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        final placesData = decodedData['candidates'];

        final place = placesData[0];

        final addressName = place['formatted_address'];
        final lat = place['geometry']['location']['lat'];
        final lng = place['geometry']['location']['lng'];

        final placeObject =
            TargetPlace(addressName: addressName, lat: lat, lng: lng);
        setState(() {
          targetPlace = placeObject;
        });
      } else {
        throw Exception('Failed to load places');
      }
    } catch (e) {
      print('Error fetching data');
    }
  }

  Future<void> destinationLocationAutocomplete(String placeId) async {
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        final place = decodedData['result'];
        final addressName = place['formatted_address'];
        final lat = place['geometry']['location']['lat'];
        final lng = place['geometry']['location']['lng'];

        final placeData =
            TargetPlace(addressName: addressName, lat: lat, lng: lng);

        setState(() {
          targetPlace = placeData;
        });
      } else {
        throw Exception('Failed to load places');
      }
    } catch (e) {
      print('Error fetching data');
    }
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> places = ref.watch(placesProvider);

    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 6, 118),
        title: Text(
          'How Can I Go ?',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: mainColor,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 50.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/map.png',
                width: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'What do you want to go ?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    Icons.search,
                  ),
                ),
                onChanged: (value) {
                  ref.read(placesProvider.notifier).fetchPlaces(value);
                },
              ),
              if (places.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(places[index]['description']!),
                      onTap: () {
                        textController.text = places[index]['description']!;
                        selectedPlaceId = places[index]['place_id'];
                        destinationLocationAutocomplete(selectedPlaceId!);
                      },
                    );
                  },
                ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  if (selectedPlaceId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapPage(
                          targetPlace: targetPlace!,
                        ),
                      ),
                    );
                  } else {
                    destinationLocationSearchManually();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapPage(
                          targetPlace: targetPlace!,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 13, 6, 118),
                        Color.fromARGB(255, 9, 78, 255),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Let\'s Go',
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: mainColor,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
