import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tracking_provider.dart';

class SpeedDisplay extends StatelessWidget {
  final bool showUnit;

  const SpeedDisplay({Key? key, this.showUnit = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trackingProvider = context.watch<TrackingProvider>();
    final speedMps = trackingProvider.currentSpeedMps;
    final kmh = speedMps * 3.6;

    final modeIcon = trackingProvider.currentMode == 'مشي'
        ? Icons.directions_walk
        : (trackingProvider.currentMode == 'قيادة'
            ? Icons.drive_eta
            : Icons.circle);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white70, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(modeIcon, size: 18),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${speedMps.toStringAsFixed(1)} ${showUnit ? 'm/s' : ''}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              Text('${kmh.toStringAsFixed(0)} km/h',
                  style: const TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
