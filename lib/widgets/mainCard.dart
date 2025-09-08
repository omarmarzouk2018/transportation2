import 'package:flutter/material.dart';
import '../models/station_model.dart';

class MainCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onClose;
  final bool isVisible;

  const MainCard({
    Key? key,
    required this.child,
    required this.onClose,
    required this.isVisible,
  }) : super(key: key);

  @override
  State<MainCard> createState() => _MainCardState();
}

class _MainCardState extends State<MainCard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _heightAnimation;
  late Animation<double> _rotationAnimation;

  Function(bool) _onMarkerColorChange = (bool value) {};

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation =
        Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 1.0), end: Offset.zero)
            .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _heightAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _rotationAnimation =
        Tween<double>(begin: -0.05, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // لو الكارت ظاهر من البداية
    if (widget.isVisible) {
      _controller.forward();
      _onMarkerColorChange(true);
    }
  }

  @override
  void didUpdateWidget(MainCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // لما المحطة تتغير
    // if (widget.station.id != oldWidget.station.id) {
    //   _controller.reset();

      // if (widget.isVisible) {
      //   _controller.forward();
      // }
    // }

    // لما خاصية الظهور تتغير
    if (widget.isVisible && !_controller.isAnimating) {
      _controller.forward();
    } else if (!widget.isVisible) {
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
    if (!widget.isVisible && _controller.status == AnimationStatus.dismissed) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SizeTransition(
            axis: Axis.vertical,
            sizeFactor: _heightAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: child,
                  );
                },
                child: _buildCard(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Material(
      elevation: 15,
      borderRadius: BorderRadius.circular(28),
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade500,
              Colors.blue.shade300,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(76), // 0.3 * 255 = 76
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color: Colors.white.withAlpha(76), // 0.3 * 255 = 76
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            widget.child,
            const SizedBox(height: 12),
            RowInfo(widget: widget),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  widget.onClose();
                  // _onMarkerColorChange(false);
                },
                icon: const Icon(Icons.close),
                label: const Text("إغلاق"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStationIcon(StationType type) {
    switch (type) {
      case StationType.Bus:
        return Icons.directions_bus;
      case StationType.tram:
        return Icons.tram;
      case StationType.metro:
        return Icons.subway;
      case StationType.MicroBus:
        return Icons.directions_bus;
      default:
        return Icons.location_on;
    }
  }
}

class RowInfo extends StatelessWidget {
  const RowInfo({
    super.key,
    required this.widget,
  });

  final MainCard widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.info_outline,
          color: Colors.white70,
          size: 18,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            "نوع المحطة: ${widget.station.type.text}",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

co = Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getStationIcon(widget.station.type),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.station.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),