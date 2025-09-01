import 'package:flutter/material.dart';

class SpeedDisplay extends StatelessWidget {
  final double speedMps;
  final String mode;
  final bool showUnit;

  const SpeedDisplay({Key? key, required this.speedMps, required this.mode, this.showUnit = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kmh = (speedMps * 3.6);
    final modeIcon = mode == 'مشي' ? Icons.directions_walk : (mode == 'قيادة' ? Icons.drive_eta : Icons.circle);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(modeIcon, size: 18),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${speedMps.toStringAsFixed(1)} ${showUnit ? 'm/s' : ''}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text('${kmh.toStringAsFixed(0)} km/h', style: const TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
