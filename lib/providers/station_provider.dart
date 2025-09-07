import 'package:flutter/material.dart';
import '../models/station_model.dart';

class StationProvider with ChangeNotifier {
  List<StationModel> _stations = StationModel.stationsList;
  List<StationModel> get stations => _stations;
  
  StationModel? _selectedStation;

  StationModel? get selectedStation => _selectedStation;
  String? get selectedStationId => _selectedStation?.id;

  bool get hasSelectedStation => _selectedStation != null;

  void selectStation(StationModel station) {
    _selectedStation = station;
    notifyListeners();
  }

  void deselectStation() {
    _selectedStation = null;
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
      final station = StationModel.stationsList.firstWhere(
        (s) => s.id == stationId,
        orElse: () => StationModel.stationsList.first,
      );
      selectStation(station);
    } else {
      deselectStation();
    }
  }
}
