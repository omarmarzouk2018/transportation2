import 'package:flutter/material.dart';
import '../models/lat_lng.dart';
import '../providers/route_provider.dart';

class ModalBottomSheet extends StatelessWidget {
  const ModalBottomSheet({
    super.key,
    required this.routeProv,
    required this.dest,
  });

  final RouteProvider routeProv;
  final LatLng dest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'اذهب إلى هذا المكان',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              routeProv.calculateAndSetRoute(dest);
              Navigator.of(context).pop();
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }
}
