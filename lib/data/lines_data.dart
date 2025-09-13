import '../models/line_model.dart';
import 'stations_data.dart';

class LinesData {
  static final abuQir_manshia = TransportLine(
    id: 'L1',
    name: "ابوقير-منشية",
    price: 10.0,
    stations: [
      StationsData.abuQir,
      StationsData.edarah,
      StationsData.mandarah,
      StationsData.manshia
    ],
  );

  static final abuQir_victoria = TransportLine(
    id: 'L2',
    name: 'ابوقير-فيكتوريا',
    price: 10.0,
    stations: [
      StationsData.abuQir,
      StationsData.edarah,
      StationsData.mandarah,
      StationsData.victoria
    ],
  );

  static final manshia_bahary = TransportLine(
    id: 'L3',
    name: 'منشية-بحري',
    price: 10.0,
    stations: [StationsData.manshia, StationsData.bahary],
  );

  static final List<TransportLine> lines = [
    LinesData.abuQir_manshia,
    LinesData.abuQir_victoria,
    LinesData.manshia_bahary,
  ];
}
