import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tracking_provider.dart';

class TrackingToggle extends StatefulWidget {
  const TrackingToggle({Key? key}) : super(key: key);

  @override
  State<TrackingToggle> createState() => _TrackingToggleState();
}

class _TrackingToggleState extends State<TrackingToggle> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final trackingProvider = context.watch<TrackingProvider>();
    return ElevatedButton.icon(
      icon: loading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(trackingProvider.isTracking ? Icons.pause : Icons.play_arrow),
      label: const Text('تشغيل/إيقاف تتبع الموقع'),
      onPressed: () async {
        setState(() {
          loading = true;
        });
        await Future.delayed(const Duration(milliseconds: 400));
        trackingProvider.toggle();
        setState(() {
          loading = false;
        });
      },
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12)),
    );
  }
}
