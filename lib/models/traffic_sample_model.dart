import 'leg_model.dart';

class TrafficSample {
  final String id;
  final String pathHash;
  final DateTime timestampUtc;
  final double averageSpeedMps;
  final int durationSeconds;
  final LegType legType;
  final Map<String, String> metadata;

  TrafficSample({
    required this.id,
    required this.pathHash,
    required this.timestampUtc,
    required this.averageSpeedMps,
    required this.durationSeconds,
    required this.legType,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'pathHash': pathHash,
        'timestampUtc': timestampUtc.toIso8601String(),
        'averageSpeedMps': averageSpeedMps,
        'durationSeconds': durationSeconds,
        'legType': legType.name,
        'metadata': metadata,
      };

  factory TrafficSample.fromJson(Map<String, dynamic> json) {
    final legTypeStr = json['legType'] as String? ?? LegType.transit.name;
    final legType = LegType.values
        .firstWhere((e) => e.name == legTypeStr, orElse: () => LegType.transit);
    return TrafficSample(
      id: json['id'] as String,
      pathHash: json['pathHash'] as String,
      timestampUtc: DateTime.parse(json['timestampUtc'] as String).toUtc(),
      averageSpeedMps: (json['averageSpeedMps'] as num).toDouble(),
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      legType: legType,
      metadata: (json['metadata'] as Map?)?.map((k, v) => MapEntry('$k', '$v')) ??
          {},
    );
  }
}
