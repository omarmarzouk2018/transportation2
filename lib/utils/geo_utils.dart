import '../models/lat_lng.dart';

double haversineDistance(LatLng a, LatLng b) => a.distanceTo(b);

double computePolylineLength(List<LatLng> polyline) {
  var sum = 0.0;
  for (var i = 1; i < polyline.length; i++) {
    sum += polyline[i - 1].distanceTo(polyline[i]);
  }
  return sum;
}

Map<String, dynamic> splitLineAtNearestPoint(List<LatLng> polyline, LatLng point) {
  if (polyline.isEmpty) return {'index': 0, 'segments': [polyline]};
  var minDist = double.infinity;
  var minIndex = 0;
  for (var i = 0; i < polyline.length; i++) {
    final d = polyline[i].distanceTo(point);
    if (d < minDist) {
      minDist = d;
      minIndex = i;
    }
  }
  final seg1 = polyline.sublist(0, minIndex + 1);
  final seg2 = polyline.sublist(minIndex);
  return {'index': minIndex, 'segments': [seg1, seg2]};
}

String hashPath(List<LatLng> path) {
  final sb = StringBuffer();
  for (final p in path) {
    sb.write('${p.latitude.toStringAsFixed(4)},${p.longitude.toStringAsFixed(4)};');
  }
  // simple hash
  return sb.toString().hashCode.toString();
}
