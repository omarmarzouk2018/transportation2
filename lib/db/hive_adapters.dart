import 'package:hive/hive.dart';
import '../models/route_model.dart';
import '../models/leg_model.dart';
import '../models/station_model.dart';
import '../models/traffic_sample_model.dart';
import '../models/lat_lng.dart';

// We'll implement TypeAdapters manually to avoid build_runner for this sample.
// However Hive needs generated adapters normally. For this example we'll create simple adapters.

class LatLngAdapter extends TypeAdapter<LatLng> {
  @override
  final int typeId = 10;

  @override
  LatLng read(BinaryReader reader) {
    final lat = reader.readDouble();
    final lon = reader.readDouble();
    return LatLng(lat, lon);
  }

  @override
  void write(BinaryWriter writer, LatLng obj) {
    writer.writeDouble(obj.latitude);
    writer.writeDouble(obj.longitude);
  }
}

class LegModelAdapter extends TypeAdapter<dynamic> {
  @override
  final int typeId = 2;

  @override
  dynamic read(BinaryReader reader) {
    final typeIndex = reader.readByte();
    final type = LegType.values[typeIndex];
    final distance = reader.readDouble();
    final duration = reader.readInt();
    final geomLen = reader.readInt();
    final geometry = <LatLng>[];
    for (var i = 0; i < geomLen; i++) {
      final lat = reader.readDouble();
      final lon = reader.readDouble();
      geometry.add(LatLng(lat, lon));
    }
    final start = reader.readString();
    final end = reader.readString();
    return LegModel(
      type: type,
      distanceMeters: distance,
      durationSeconds: duration,
      geometry: geometry,
      startStationId: start.isEmpty ? null : start,
      endStationId: end.isEmpty ? null : end,
    );
  }

  @override
  void write(BinaryWriter writer, obj) {
    writer.writeByte(obj.type.index);
    writer.writeDouble(obj.distanceMeters);
    writer.writeInt(obj.durationSeconds);
    writer.writeInt(obj.geometry.length);
    for (final p in obj.geometry) {
      writer.writeDouble(p.latitude);
      writer.writeDouble(p.longitude);
    }
    writer.writeString(obj.startStationId ?? '');
    writer.writeString(obj.endStationId ?? '');
  }
}

class RouteModelAdapter extends TypeAdapter<RouteModel> {
  @override
  final int typeId = 1;

  @override
  RouteModel read(BinaryReader reader) {
    final id = reader.readString();
    final originLat = reader.readDouble();
    final originLon = reader.readDouble();
    final destLat = reader.readDouble();
    final destLon = reader.readDouble();
    final legsCount = reader.readInt();
    final legs = <LegModel>[];
    for (var i = 0; i < legsCount; i++) {
      // Use LegModelAdapter logic: read byte etc.
      final typeIndex = reader.readByte();
      final type = LegType.values[typeIndex];
      final distance = reader.readDouble();
      final duration = reader.readInt();
      final geomLen = reader.readInt();
      final geometry = <LatLng>[];
      for (var j = 0; j < geomLen; j++) {
        final lat = reader.readDouble();
        final lon = reader.readDouble();
        geometry.add(LatLng(lat, lon));
      }
      final start = reader.readString();
      final end = reader.readString();
      legs.add(
        LegModel(
          type: type,
          distanceMeters: distance,
          durationSeconds: duration,
          geometry: geometry,
          startStationId: start.isEmpty ? null : start,
          endStationId: end.isEmpty ? null : end,
        ),
      );
    }
    final totalDistance = reader.readDouble();
    final totalDuration = reader.readInt();
    final createdAtIso = reader.readString();
    final createdAt = DateTime.parse(createdAtIso).toUtc();
    return RouteModel(
      id: id,
      origin: LatLng(originLat, originLon),
      destination: LatLng(destLat, destLon),
      legs: legs,
      totalDistanceMeters: totalDistance,
      totalDurationSeconds: totalDuration,
      createdAt: createdAt,
    );
  }

  @override
  void write(BinaryWriter writer, RouteModel obj) {
    writer.writeString(obj.id);
    writer.writeDouble(obj.origin.latitude);
    writer.writeDouble(obj.origin.longitude);
    writer.writeDouble(obj.destination.latitude);
    writer.writeDouble(obj.destination.longitude);
    writer.writeInt(obj.legs.length);
    for (final l in obj.legs) {
      writer.writeByte(l.type.index);
      writer.writeDouble(l.distanceMeters);
      writer.writeInt(l.durationSeconds);
      writer.writeInt(l.geometry.length);
      for (final p in l.geometry) {
        writer.writeDouble(p.latitude);
        writer.writeDouble(p.longitude);
      }
      writer.writeString(l.startStationId ?? '');
      writer.writeString(l.endStationId ?? '');
    }
    writer.writeDouble(obj.totalDistanceMeters);
    writer.writeInt(obj.totalDurationSeconds);
    writer.writeString(obj.createdAt.toIso8601String());
  }
}

class StationModelAdapter extends TypeAdapter<StationModel> {
  @override
  final int typeId = 3;

  @override
  StationModel read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final lat = reader.readDouble();
    final lon = reader.readDouble();
    final typeIndex = reader.readByte();
    final attrsLen = reader.readInt();
    final attrs = <String, String>{};
    for (var i = 0; i < attrsLen; i++) {
      final k = reader.readString();
      final v = reader.readString();
      attrs[k] = v;
    }
    final type = StationType.values[typeIndex];
    return StationModel(
      id: id,
      name: name,
      location: LatLng(lat, lon),
      type: type,
    );
  }

  @override
  void write(BinaryWriter writer, StationModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeDouble(obj.location.latitude);
    writer.writeDouble(obj.location.longitude);
    writer.writeByte(obj.type.index);
  }
}

class TrafficSampleAdapter extends TypeAdapter<dynamic> {
  @override
  final int typeId = 4;

  @override
  dynamic read(BinaryReader reader) {
    final id = reader.readString();
    final pathHash = reader.readString();
    final timestamp = DateTime.parse(reader.readString()).toUtc();
    final avgSpeed = reader.readDouble();
    final duration = reader.readInt();
    final legTypeIndex = reader.readByte();
    final metaLen = reader.readInt();
    final meta = <String, String>{};
    for (var i = 0; i < metaLen; i++) {
      final k = reader.readString();
      final v = reader.readString();
      meta[k] = v;
    }
    return TrafficSample(
      id: id,
      pathHash: pathHash,
      timestampUtc: timestamp,
      averageSpeedMps: avgSpeed,
      durationSeconds: duration,
      legType: LegType.values[legTypeIndex],
      metadata: meta,
    );
  }

  @override
  void write(BinaryWriter writer, obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.pathHash);
    writer.writeString(obj.timestampUtc.toIso8601String());
    writer.writeDouble(obj.averageSpeedMps);
    writer.writeInt(obj.durationSeconds);
    writer.writeByte(obj.legType.index);
    writer.writeInt(obj.metadata.length);
    obj.metadata.forEach((k, v) {
      writer.writeString(k);
      writer.writeString(v);
    });
  }
}

void registerAdapters() {
  Hive.registerAdapter(RouteModelAdapter());
  Hive.registerAdapter(LegModelAdapter());
  Hive.registerAdapter(StationModelAdapter());
  Hive.registerAdapter(TrafficSampleAdapter());
  Hive.registerAdapter(LatLngAdapter());
}
