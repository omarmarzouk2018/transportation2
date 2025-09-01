import 'package:flutter/material.dart';

class TrackingToggle extends StatefulWidget {
  final bool isTracking;
  final VoidCallback onToggle;

  const TrackingToggle({Key? key, required this.isTracking, required this.onToggle}) : super(key: key);

  @override
  State<TrackingToggle> createState() => _TrackingToggleState();
}

class _TrackingToggleState extends State<TrackingToggle> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : Icon(widget.isTracking ? Icons.pause : Icons.play_arrow),
      label: const Text('تشغيل/إيقاف تتبع الموقع'),
      onPressed: () async {
        setState(() { loading = true; });
        await Future.delayed(const Duration(milliseconds: 400));
        widget.onToggle();
        setState(() { loading = false; });
      },
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12)),
    );
  }
}
