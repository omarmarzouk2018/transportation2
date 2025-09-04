import 'package:flutter/material.dart';
import '../models/station_model.dart';


class StationCard extends StatelessWidget {
  final StationModel station;
  final VoidCallback onClose;
  final bool isVisible;

  const StationCard({
    Key? key,
    required this.station,
    required this.onClose,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      offset: isVisible ? Offset.zero : const Offset(0, 1), // يطلع من تحت
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isVisible ? 1 : 0,
        child: Align(
          alignment: Alignment.center,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    station.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("نوع المحطة: ${station.type.text}"),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: onClose,
                    icon: const Icon(Icons.close),
                    label: const Text("إغلاق"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
