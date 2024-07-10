import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:how_can_i_go_app/constants/constants.dart';
import 'package:how_can_i_go_app/models/target_place.dart';
import 'package:how_can_i_go_app/pages/map/widgets/transportation_buttons.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.targetPlace});

  final TargetPlace targetPlace;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location location = Location();
  LatLng? currentPosition;
  List<LatLng> polylineCoordinates = [];
  GoogleMapController? mapController;

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });
  }

  Future<void> getRoute(TravelMode mode) async {
    polylineCoordinates.clear();
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: apiKey,
      request: PolylineRequest(
        origin:
            PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
        destination:
            PointLatLng(widget.targetPlace.lat!, widget.targetPlace.lng!),
        mode: mode,
      ),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 6, 118),
        foregroundColor: mainColor,
        centerTitle: true,
        title: Text(
          'How Can I Go ?',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: mainColor,
              ),
        ),
      ),
      body: (currentPosition == null)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        widget.targetPlace.lat!,
                        widget.targetPlace.lng!,
                      ),
                      zoom: 15,
                    ),
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId('route'),
                        points: polylineCoordinates,
                        color: Colors.blue,
                        width: 6,
                      ),
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId(
                          'current_position',
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue,
                        ),
                        position: currentPosition!,
                      ),
                      Marker(
                        markerId: const MarkerId(
                          'target_position',
                        ),
                        icon: BitmapDescriptor.defaultMarker,
                        position: LatLng(
                          widget.targetPlace.lat!,
                          widget.targetPlace.lng!,
                        ),
                      ),
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 20.0),
                      child: Column(
                        children: [
                          TransportationButtons(
                            onPressed: getRoute,
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  mapController?.animateCamera(
                                    CameraUpdate.newLatLng(currentPosition!),
                                  );
                                },
                                icon: const Icon(
                                  Icons.my_location,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 10.0),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 228, 228, 228),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    'Your Current Location',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  mapController?.animateCamera(
                                    CameraUpdate.newLatLng(LatLng(
                                        widget.targetPlace.lat!,
                                        widget.targetPlace.lng!)),
                                  );
                                },
                                icon: const Icon(
                                  Icons.location_on_outlined,
                                  size: 50,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 10.0),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 228, 228, 228),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    widget.targetPlace.addressName!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
