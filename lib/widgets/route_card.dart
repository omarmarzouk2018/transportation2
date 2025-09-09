import 'package:flutter/material.dart';
import '../models/lat_lng.dart';
import 'package:provider/provider.dart';
import '../providers/route_provider.dart';

class RouteCard extends StatelessWidget {
  final LatLng dest;

  const RouteCard({
    super.key,
    required this.dest,
  });

  @override
  Widget build(BuildContext context) {
    final routeProv = Provider.of<RouteProvider>(context, listen: false);
    
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'اذهب إلى هذا المكان',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                routeProv.calculateAndSetRoute(dest);
              },
              child: const Text('تأكيد'),
            ),
          ],
        ),
      ),
    );
  }
}
