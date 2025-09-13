import 'package:flutter/material.dart';
import '../data/stations_data.dart';
import '../models/station_model.dart';

class StationProvider with ChangeNotifier {
  List<StationModel> _stations = StationsData.stationsList;
  List<StationModel> get stations => _stations;

  StationModel? _selectedStation;
  StationModel? get selectedStation => _selectedStation;
  String? get selectedStationId => _selectedStation?.id;

  bool _isCardVisible = false;
  bool get isCardVisible => _isCardVisible;

  bool get hasSelectedStation => _selectedStation != null;

  void selectStation(StationModel station) {
    _selectedStation = station;
    _isCardVisible = true;
    notifyListeners();
  }

  void deselectStation() {
    _selectedStation = null;
    _isCardVisible = false;
    notifyListeners();
  }

  bool isStationSelected(StationModel station) {
    return _selectedStation?.id == station.id;
  }

  void setStations(List<StationModel> stations) {
    _stations = stations;
    notifyListeners();
  }

  void updateStationSelection(String? stationId, bool isSelected) {
    if (isSelected && stationId != null) {
      // ابحث عن المحطة بناءً على المعرف
      final station = StationsData.stationsList.firstWhere(
        (s) => s.id == stationId,
        orElse: () => StationsData.stationsList.first,
      );
      selectStation(station);
    } else {
      deselectStation();
    }
  }
}
