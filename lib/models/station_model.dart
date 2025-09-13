import 'lat_lng.dart';

enum StationType {
  Bus("أتوبيس"),
  tram("ترام"),
  metro("مترو"),
  MicroBus("ميكروباص");

  final String text;
  const StationType(this.text);
}

class StationModel {
  final String id;
  final String name;
  final LatLng location;
  final StationType type;

  StationModel({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
  });

}


  // factory StationModel.fromJson(Map<String, dynamic> json) {
  //   
  //   final loc = (json['location'] is Map)
  //       ? LatLng.fromJson(json['location'] as Map<String, dynamic>)
  //       : LatLng(0, 0);

  //   // Parse lines list
  //   final linesList = <TransportLine>[];
  //   if (json['lines'] is List) {
  //     for (var line in (json['lines'] as List)) {
  //       if (line is Map<String, dynamic>) {
  //         linesList.add(TransportLine.fromJson(line));
  //       }
  //     }
  //   }

  //   return StationModel(
  //     id: json['id'] ?? '',
  //     name: json['name'] ?? '',
  //     location: loc,
  //     type: type,
  //     lines: linesList,
  //   );
  // }

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'name': name,
  //       'location': location.toJson(),
  //       'type': type.name,
  //       'lines': lines,
  //     };
