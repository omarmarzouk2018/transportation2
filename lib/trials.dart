import 'package:alex_transit/data/stations_repository.dart';
import 'models/station_model.dart';
import 'data/stations_repository.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  StationsRepository.loadStations().then((stations) {
    
  });
}



// dart run trials.dart
// flutter run -t lib/trials.dart