import 'package:flutter/material.dart';
import '../models/lat_lng.dart';
import 'mainCard.dart';
import 'package:provider/provider.dart';
import '../providers/route_provider.dart';

class DestinationCard extends StatelessWidget {
  final LatLng dest;
  final VoidCallback onClose;
  final bool isVisible;

  const DestinationCard({
    Key? key,
    required this.dest,
    required this.onClose,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeProv = Provider.of<RouteProvider>(context, listen: false);
    return MainCard(
      isVisible: isVisible,
      onClose: onClose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.flag, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                "اذهب إلى هذا المكان",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Text(
            "إحداثيات: ${dest.latitude}, ${dest.longitude}",
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
