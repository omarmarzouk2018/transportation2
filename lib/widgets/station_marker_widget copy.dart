import 'package:flutter/material.dart';
import '../models/station_model.dart';

class StationMarkerWidget extends StatelessWidget {
  final StationModel station;
  final VoidCallback onTap;
  final bool isSelected;

  const StationMarkerWidget(
      {Key? key, required this.station, required this.onTap, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = isSelected ? 66.0 : 56.0;
    final ringColor = isSelected ? Colors.blue : Colors.transparent;
    // final ringColor = isSelected? Theme.of(context).colorScheme.primary: Colors.black.withOpacity(0.2);
   
    return GestureDetector(
      onTap: onTap,
      // child: SizedBox(width: 80,height: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 40,
            ),
            Flexible(
              child: Text(
                station.name,
                style: const TextStyle(fontSize: 10),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      // ),
    );
  }
}
