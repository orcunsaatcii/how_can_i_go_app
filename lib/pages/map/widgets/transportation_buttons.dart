import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:how_can_i_go_app/providers/transportation_provider.dart';

class TransportationButtons extends ConsumerStatefulWidget {
  const TransportationButtons({super.key, required this.onPressed});

  final Future<void> Function(TravelMode) onPressed;

  @override
  ConsumerState<TransportationButtons> createState() =>
      _TransportationButtonState();
}

class _TransportationButtonState extends ConsumerState<TransportationButtons> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final activeTransportation = ref.watch(transportationProvider);
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              ref
                  .read(transportationProvider.notifier)
                  .changeTransportation(Transportation.driving);

              widget.onPressed(TravelMode.driving);
            },
            child: Container(
              height: screenHeight * 0.10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 228, 228, 228),
                border: Border.all(
                  color: activeTransportation == Transportation.driving
                      ? Colors.blue
                      : const Color.fromARGB(255, 228, 228, 228),
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/car.png',
                    fit: BoxFit.cover,
                    width: 50,
                  ),
                  Center(
                    child: Text(
                      'Car',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              ref
                  .read(transportationProvider.notifier)
                  .changeTransportation(Transportation.transit);

              widget.onPressed(TravelMode.transit);
            },
            child: Container(
              height: screenHeight * 0.10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 228, 228, 228),
                border: Border.all(
                  color: activeTransportation == Transportation.transit
                      ? Colors.blue
                      : const Color.fromARGB(255, 228, 228, 228),
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/bus.png',
                    fit: BoxFit.cover,
                    width: 50,
                  ),
                  Center(
                    child: Text(
                      'Transit',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              ref
                  .read(transportationProvider.notifier)
                  .changeTransportation(Transportation.walking);

              widget.onPressed(TravelMode.walking);
            },
            child: Container(
              height: screenHeight * 0.10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 228, 228, 228),
                border: Border.all(
                  color: activeTransportation == Transportation.walking
                      ? Colors.blue
                      : const Color.fromARGB(255, 228, 228, 228),
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/walking.png',
                    fit: BoxFit.cover,
                    width: 50,
                  ),
                  Center(
                    child: Text(
                      'Walking',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              ref
                  .read(transportationProvider.notifier)
                  .changeTransportation(Transportation.bicycling);

              widget.onPressed(TravelMode.bicycling);
            },
            child: Container(
              height: screenHeight * 0.10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 228, 228, 228),
                border: Border.all(
                  color: activeTransportation == Transportation.bicycling
                      ? Colors.blue
                      : const Color.fromARGB(255, 228, 228, 228),
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/bicycle.png',
                    fit: BoxFit.cover,
                    width: 50,
                  ),
                  Center(
                    child: Text(
                      'Bicycle',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
