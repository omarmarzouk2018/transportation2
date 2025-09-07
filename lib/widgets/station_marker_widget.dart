import 'package:alex_transit/services/dimensions.dart';
import 'package:flutter/material.dart';
import '../models/station_model.dart';
import 'package:provider/provider.dart';
import '../providers/station_provider.dart';

class StationMarkerWidget extends StatefulWidget {
  final StationModel station;

  const StationMarkerWidget({
    Key? key,
    required this.station,
  }) : super(key: key);

  @override
  _StationMarkerWidgetState createState() => _StationMarkerWidgetState();
}

class _StationMarkerWidgetState extends State<StationMarkerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    final initialSize = AppDimensions.stationIconNormal * 0.8;
    final selectedSize = AppDimensions.stationMarkerWidth * 0.8;
    _sizeAnimation = Tween<double>(begin: initialSize, end: selectedSize)
        .animate(curvedAnimation);

    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.blue,
    ).animate(curvedAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StationProvider>(
      builder: (context, stationProvider, child) {
        final isSelected =
            stationProvider.selectedStation?.id == widget.station.id;

        // حرك الأنيميشن على حسب الاختيار
        if (isSelected) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
        return GestureDetector(
          onTap: () =>
              context.read<StationProvider>().selectStation(widget.station),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final currentSize = _sizeAnimation.value;
              final currentColor = _colorAnimation.value;
              final iconColor = isSelected ? Colors.white : Colors.red;

              return Container(
                width: currentSize,
                height: currentSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentColor,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.red,
                    width: isSelected ? 0 : 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 50),
                      blurRadius: isSelected ? 6 : 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Icon(
                    Icons.directions_bus_filled_outlined,
                    size: currentSize * 0.8,
                    color: iconColor,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
