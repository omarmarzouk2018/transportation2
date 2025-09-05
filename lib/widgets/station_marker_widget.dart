import 'package:alex_transit/services/dimensions.dart';
import 'package:flutter/material.dart';
import '../models/station_model.dart';

class StationMarkerWidget extends StatefulWidget {
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
      // جعل مدة الحركة قريبة من مدة حركة الكارد للتناغم
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // استخدام Curves.elasticOut ليتناسب مع حركة الكارد
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    // تحديد الحجم الأولي والنهائي للعلامة
    final initialSize = AppDimensions.stationIconNormal * 0.8;
    final selectedSize = AppDimensions.stationMarkerWidth * 0.8;
    _sizeAnimation = Tween<double>(begin: initialSize, end: selectedSize)
        .animate(curvedAnimation);

    // تحديد اللون الأولي والنهائي للخلفية والأيقونة
    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.blue,
    ).animate(curvedAnimation);

    // تشغيل الحركة بناءً على الحالة الأولية
    if (widget.isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(StationMarkerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // تشغيل الحركة عند تغير حالة الاختيار
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // الحصول على قيم الحركة الحالية
          final currentSize = _sizeAnimation.value;
          final currentColor = _colorAnimation.value;
          final iconColor = widget.isSelected ? Colors.white : Colors.red;

          return Container(
            width: currentSize,
            height: currentSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentColor,
              border: Border.all(
                color: widget.isSelected ? Colors.blue : Colors.red,
                width: widget.isSelected ? 0 : 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 50),
                  blurRadius: widget.isSelected ? 6 : 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Icon(
                Icons.directions_bus_filled_outlined,
                // حجم الأيقونة يتغير مع حجم الحاوية
                size: currentSize * 0.8,
                color: iconColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
