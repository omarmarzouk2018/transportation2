import 'package:flutter/material.dart';
import '../models/station_model.dart';

class DragedBottomSheet extends StatelessWidget {
  const DragedBottomSheet({
    super.key,
    required this.station,
  });

  final StationModel station;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.25,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    station.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('نوع المحطة: ${station.type.text}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('اغلاق'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
