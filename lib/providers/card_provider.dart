import 'package:flutter/material.dart';
import '../models/station_model.dart';

class CardProvider with ChangeNotifier {
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
