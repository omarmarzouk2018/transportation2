import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/route_provider.dart';
import '../providers/tracking_provider.dart';

class RouteDetailScreen extends StatelessWidget {
  final String routeId;
  const RouteDetailScreen({Key? key, required this.routeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rp = Provider.of<RouteProvider>(context);
    final route = rp.favorites.firstWhere((r) => r.id == routeId, orElse: () => rp.activeRoute!);
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المسار')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text('Origin: ${route.origin}'),
            Text('Destination: ${route.destination}'),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: () {
                  // start navigation
                  final tp = Provider.of<TrackingProvider>(context, listen: false);
                  tp.start();
                },
                child: const Text('بدء التنقل'),),
            const SizedBox(height: 12),
            Expanded(
                child: ListView(
              children: route.legs.map((l) {
                return ListTile(
                  title: Text(l.type.name),
                  subtitle: Text('${(l.distanceMeters / 1000).toStringAsFixed(2)} كم • ${(l.durationSeconds / 60).round()} دقيقة'),
                );
              }).toList(),
            ),),
          ],
        ),
      ),
    );
  }
}
