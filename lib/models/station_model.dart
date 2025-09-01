import 'lat_lng.dart';

enum StationType { Bus, tram, metro, ferry, MicroBus }

class StationModel {
  final String id;
  final String name;
  final LatLng location;
  final StationType type;
  final Map<String, String> attributes;

  StationModel({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    this.attributes = const {},
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    final typeStr = (json['type'] as String?) ?? 'bus';
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
      case 'ferry':
        type = StationType.ferry;
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
    final attrs = <String, String>{};
    if (json['attributes'] is Map) {
      (json['attributes'] as Map).forEach((k, v) {
        attrs['$k'] = '$v';
      });
    }
    return StationModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: loc,
      type: type,
      attributes: attrs,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location.toJson(),
        'type': type.name,
        'attributes': attributes,
      };
}
