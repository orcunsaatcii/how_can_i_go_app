import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Transportation {
  nothing,
  driving,
  transit,
  walking,
  bicycling,
}

class TransportationNotifier extends StateNotifier<Enum> {
  TransportationNotifier() : super(Transportation.nothing);

  void changeTransportation(Enum transportation) {
    state = transportation;
  }
}

final transportationProvider =
    StateNotifierProvider<TransportationNotifier, Enum>(
  (ref) => TransportationNotifier(),
);
