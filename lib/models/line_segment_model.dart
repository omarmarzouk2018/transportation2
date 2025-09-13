import 'package:latlong2/latlong.dart';

import 'station_model.dart';

class LineSegmentModel {
  final StationModel station1;
  final StationModel station2;
  final List<List<double>> rawCoordinations;
  final double? price;

  const LineSegmentModel({
    required this.station1,
    required this.station2,
    required this.rawCoordinations,
    this.price,
  });

  List<LatLng> get coordinations => rawCoordinations
      .map((rawcoors) => LatLng(rawcoors[1], rawcoors[0]))
      .toList();
  @override
  String toString() {
    return 'LineSegmentModel{station1: $station1, station2: $station2, price: $price}';
  }
}
