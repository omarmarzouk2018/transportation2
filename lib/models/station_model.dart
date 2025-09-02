import 'lat_lng.dart';

enum StationType { Bus, tram, metro, MicroBus }

class StationModel {
  final String id;
  final String name;
  final LatLng location;
  final StationType type;
  final List<Map<String, dynamic>> lines;

  StationModel({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    this.lines = const [],
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    final typeStr = (json['type'] as String?) ?? 'MicroBus';

    StationType type;
    switch (typeStr) {
      case 'MicroBus':
        type = StationType.MicroBus;
        break;
      case 'tram':
        type = StationType.tram;
        break;
      case 'metro':
        type = StationType.metro;
        break;
      case 'Bus':
        type = StationType.Bus;
        break;
      default:
        type = StationType.MicroBus;
    }

    final loc = (json['location'] is Map)
        ? LatLng.fromJson(json['location'] as Map<String, dynamic>)
        : LatLng(0, 0);

    // Parse lines list
    final parsedLines = <Map<String, dynamic>>[];
    if (json['lines'] is List) {
      for (var line in (json['lines'] as List)) {
        if (line is Map<String, dynamic>) {
          parsedLines.add({
            'id': line['id'] ?? '',
            'stop_number': line['stop_number'] ?? 0,
          });
        }
      }
    }

    return StationModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: loc,
      type: type,
      lines: parsedLines,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location.toJson(),
        'type': type.name,
        'lines': lines,
      };
}


