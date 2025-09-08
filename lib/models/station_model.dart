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

  static final StationModel abuQir = StationModel(
      id: 'st_001',
      name: "أبوقير",
      location: LatLng(31.321152, 30.063232),
      type: StationType.MicroBus);

  static final StationModel edara = StationModel(
      id: 'st_002',
      name: "الإدارة",
      location: LatLng(31.304329, 30.057781),
      type: StationType.MicroBus);

  static final StationModel mandarah = StationModel(
      id: 'st_003',
      name: "المندرة",
      location: LatLng(31.280407, 30.016167),
      type: StationType.MicroBus);

  static final StationModel manshia = StationModel(
      id: 'st_004',
      name: "المنشية",
      location: LatLng(31.200489, 29.893809),
      type: StationType.MicroBus);

  static final StationModel victoria = StationModel(
    id: 'st_005',
    name: 'فيكتوريا',
    location: LatLng(31.249588, 29.980408),
    type: StationType.MicroBus,
  );

  static final StationModel egyptStation = StationModel(
    id: 'st_006',
    name: 'محطة مصر',
    location: LatLng(31.192968, 29.903205),
    type: StationType.MicroBus,
  );

  static final StationModel bahary = StationModel(
    id: 'st_007',
    name: 'بحري',
    location: LatLng(31.209957, 29.882043),
    type: StationType.MicroBus,
  );
  static final StationModel sidiGaber = StationModel(
    id: 'st_008',
    name: 'سيدي جابر',
    location: LatLng(31.218819, 29.943111),
    type: StationType.MicroBus,
  );

  static final List<StationModel> stationsList = [
    abuQir,
    edara,
    mandarah,
    manshia,
    victoria,
    egyptStation,
    bahary,
    sidiGaber,
  ];
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
