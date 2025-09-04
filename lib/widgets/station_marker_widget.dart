import 'package:alex_transit/services/dimensions.dart';
import 'package:flutter/material.dart';
import '../models/station_model.dart';

class StationMarkerWidget extends StatelessWidget {
  final StationModel station;
  final VoidCallback onTap;
  final bool isSelected;

  const StationMarkerWidget(
      {Key? key,
      required this.station,
      required this.onTap,
      this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = isSelected
        ? AppDimensions.stationIconSelected
        : AppDimensions.stationIconNormal;
    final ringColor =
        isSelected ? Colors.blue : Theme.of(context).colorScheme.primary;
    // final ringColor = isSelected? Theme.of(context).colorScheme.primary: Colors.black.withOpacity(0.2);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: ringColor, width: isSelected ? 6 : 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 50),
                  blurRadius: isSelected ? 12 : 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Icon(
                Icons.directions_bus_filled_outlined,
                size: size,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 4),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size * 1.8),
            child: Text(
              station.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
