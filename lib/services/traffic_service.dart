import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import '../models/traffic_sample_model.dart';

class TrafficService {
  TrafficService._internal();
  static final TrafficService instance = TrafficService._internal();

  final String boxName = 'traffic_samples';
  Box? _box;

  Future<void> init() async {
    _box = Hive.box(boxName);
  }

  Future<void> collectTripSample(TrafficSample sample) async {
    await _box?.put(sample.id, sample.toJson());
  }

  Map<String, double> predictBusyHours(String pathHash, DateTime date) {
    // 24 hour map string->score
    final map = <String, double>{};
    for (var h = 0; h < 24; h++) {
      map[h.toString().padLeft(2, '0')] = 0.0;
    }
    if (_box == null) return map;
    final samples = _box!.values
        .where((v) =>
            v is Map &&
            v['pathHash'] == pathHash &&
            DateTime.parse(v['timestampUtc']).toUtc().year == date.toUtc().year,)
        .map((v) => v as Map)
        .toList();
    final grouped = <int, List<Map>>{};
    for (final s in samples) {
      final dt = DateTime.parse(s['timestampUtc'] as String).toUtc();
      grouped.putIfAbsent(dt.hour, () => []).add(s);
    }
    for (final e in grouped.entries) {
      final avgSpeed = e.value
              .map((m) => (m['averageSpeedMps'] as num).toDouble())
              .fold<double>(0.0, (p, c) => p + c) /
          e.value.length;
      final freeFlow = 8.33; // driving as default
      final busyScore = (1.0 - (avgSpeed / freeFlow)).clamp(0.0, 1.0);
      map[e.key.toString().padLeft(2, '0')] = double.parse(busyScore.toStringAsFixed(2));
    }
    return map;
  }

  Future<void> exportSamplesApi(Uri url) async {
    // send all samples as example
    if (_box == null) return;
    final payload = _box!.values.toList();
    // Do an HTTP POST - omitted for brevity.
  }

  Future<List<Map>> getHourlySummary(String pathHash) async {
    final result = <Map>[];
    if (_box == null) return result;
    final samples = _box!.values.where((v) => (v as Map)['pathHash'] == pathHash).toList();
    // aggregate by hour
    final byHour = <int, List<Map>>{};
    for (final s in samples) {
      final dt = DateTime.parse((s as Map)['timestampUtc'] as String).toUtc();
      byHour.putIfAbsent(dt.hour, () => []).add(s);
    }
    for (var h = 0; h < 24; h++) {
      final list = byHour[h] ?? [];
      final avg = list.isEmpty
          ? 0.0
          : list
                  .map((m) => (m['averageSpeedMps'] as num).toDouble())
                  .fold<double>(0.0, (p, c) => p + c) /
              list.length;
      result.add({'hour': h, 'avgSpeed': avg});
    }
    return result;
  }

  Future<void> clearSamplesOlderThan(Duration d) async {
    if (_box == null) return;
    final cutoff = DateTime.now().toUtc().subtract(d);
    final keysToDelete = <dynamic>[];
    for (final key in _box!.keys) {
      final v = _box!.get(key);
      if (v is Map) {
        final ts = DateTime.parse(v['timestampUtc'] as String).toUtc();
        if (ts.isBefore(cutoff)) keysToDelete.add(key);
      }
    }
    for (final k in keysToDelete) {
      await _box!.delete(k);
    }
  }

  String anonymizePath(List<dynamic> coords) {
    final sb = StringBuffer();
    for (final c in coords) {
      sb.write('${c[0].toStringAsFixed(4)},${c[1].toStringAsFixed(4)};');
    }
    final bytes = utf8.encode(sb.toString());
    return sha256.convert(bytes).toString();
  }
}
