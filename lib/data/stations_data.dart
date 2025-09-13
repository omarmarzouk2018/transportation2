import '../models/lat_lng.dart';
import '../models/station_model.dart';

class StationsData {
  static final StationModel abuQir = StationModel(
      id: 'L1_001',
      name: "أبوقير",
      location: LatLng(31.321152, 30.063232),
      type: StationType.MicroBus);

  static final StationModel edarah = StationModel(
      id: 'L1_002',
      name: "الإدارة",
      location: LatLng(31.304409, 30.057623),
      type: StationType.MicroBus);

  static final StationModel mandarah = StationModel(
      id: 'L1_003',
      name: "المندره",
      location: LatLng(31.280407, 30.016167),
      type: StationType.MicroBus);

  static final StationModel mandarahMosque = StationModel(
      id: 'L1_004',
      name: "جامع المندره",
      location: LatLng(31.279976, 30.01211),
      type: StationType.MicroBus);

  static final StationModel victoria = StationModel(
    id: 'L1_005',
    name: 'فيكتوريا',
    location: LatLng(31.249588, 29.980408),
    type: StationType.MicroBus,
  );

  static final StationModel sidiGaber = StationModel(
    id: 'L1_006',
    name: 'سيدي جابر',
    location: LatLng(31.220148, 29.942567),
    type: StationType.MicroBus,
  );

  static final StationModel egyptStation = StationModel(
    id: 'L1_007',
    name: 'محطة مصر',
    location: LatLng(31.192968, 29.903205),
    type: StationType.MicroBus,
  );

  static final StationModel manshia = StationModel(
      id: 'L2_001',
      name: "المنشية",
      location: LatLng(31.200489, 29.893809),
      type: StationType.MicroBus);

  static final StationModel bahary = StationModel(
    id: 'L2_002',
    name: 'بحري',
    location: LatLng(31.209957, 29.882043),
    type: StationType.MicroBus,
  );

  static final List<StationModel> stationsList = [
    abuQir,
    edarah,
    mandarah,
    mandarahMosque,
    manshia,
    victoria,
    egyptStation,
    bahary,
    sidiGaber,
  ];
}
