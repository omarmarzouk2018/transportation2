import 'station_model.dart';

class TransportLine {
  final String id;
  final String name;
  final double price;
  final List<StationModel> stations;

  TransportLine(
      {required this.id,
      required this.name,
      required this.price,
      required this.stations});

  static final abuQir_manshia = TransportLine(
    id: 'L1',
    name: "ابوقير-منشية",
    price: 10.0,
    stations: [
      StationModel.abuQir,
      StationModel.edara,
      StationModel.mandarah,
      StationModel.manshia
    ],
  );

  static final abuQir_victoria = TransportLine(
    id: 'L2',
    name: 'ابوقير-فيكتوريا',
    price: 10.0,
    stations: [
      StationModel.abuQir,
      StationModel.edara,
      StationModel.mandarah,
      StationModel.victoria
    ],
  );

  static final manshia_bahary = TransportLine(
    id: 'L3',
    name: 'منشية-بحري',
    price: 10.0,
    stations: [StationModel.manshia, StationModel.bahary],
  );

  static final List<TransportLine> lines = [
    TransportLine.abuQir_manshia,
    TransportLine.abuQir_victoria,
    TransportLine.manshia_bahary,
  ];
}

  // factory TransportLine.fromJson(Map<String, dynamic> json) {
  //   return TransportLine(
  //     id: json['id'] ?? '',
  //     name: json['name'] ?? '',
  //     price: json['price'] ?? 0.0,
  //     // stations: List<String>.from(json['stations'] ?? []),
  //   );
  // }

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'name': name,
  //       'price': price,
  //       'stations': stations,
  //     };

// Future<List<StationModel>> getStationsForLine(
//     List<StationModel> allStations, String lineName) async {
//   // filter the stations to get the ones in the required lines
//   final stationsOnLine = allStations.where((station) {
//     return station.lines.any((line) => line.name == lineName);
//   }).toList();

//   // sort the stations by order
//   stationsOnLine.sort((a, b) {
//     final stopA = a.lines.firstWhere((l) => l.name == lineName).order;
//     final stopB = b.lines.firstWhere((l) => l.name == lineName).order;
//     return stopA.compareTo(stopB);
//   });

//   return stationsOnLine;
// }
