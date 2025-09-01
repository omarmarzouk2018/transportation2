import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/route_model.dart';
import '../providers/route_provider.dart';
import '../providers/tracking_provider.dart';
import '../services/notification_service.dart';
import '../models/leg_model.dart';

class RouteDetailsPanel extends StatefulWidget {
  final RouteModel route;
  const RouteDetailsPanel({Key? key, required this.route}) : super(key: key);

  @override
  State<RouteDetailsPanel> createState() => _RouteDetailsPanelState();
}

class _RouteDetailsPanelState extends State<RouteDetailsPanel> {
  bool notifyOnArrival = false;

  @override
  Widget build(BuildContext context) {
    final rp = Provider.of<RouteProvider>(context);
    final tp = Provider.of<TrackingProvider>(context);
    final etaMinutes = (widget.route.totalDurationSeconds / 60).round();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ملخص المسار - ETA: $etaMinutes دقيقة',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...widget.route.legs.map((l) {
            final label = l.type == LegType.walk_to
                ? 'المشي إلى المحطة'
                : (l.type == LegType.transit
                    ? 'ركوب/قيادة'
                    : 'المشي إلى الوجهة');
            return ListTile(
              leading: Icon(
                l.type == LegType.transit
                    ? Icons.directions_bus
                    : Icons.directions_walk,
              ),
              title: Text(label),
              subtitle: Text(
                '${(l.distanceMeters / 1000).toStringAsFixed(2)} كم • ${(l.durationSeconds / 60).round()} دقيقة',
              ),
            );
          }).toList(),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  rp.saveActiveRouteAsFavorite(
                    'المسار المفضل ${DateTime.now().toIso8601String()}',
                  );
                },
                child: const Text('حفظ كمسار مفضل'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    notifyOnArrival = !notifyOnArrival;
                  });
                  if (notifyOnArrival) {
                    NotificationService.instance.scheduleArrivalAlert(
                      widget.route,
                      widget.route.legs.last,
                    );
                  }
                },
                child: Text(
                  notifyOnArrival ? 'إيقاف الإشعار' : 'تفعيل إشعار الوصول',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
