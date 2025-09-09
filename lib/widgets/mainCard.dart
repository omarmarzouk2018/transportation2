import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 1.0), end: Offset.zero).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _heightAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotationAnimation = Tween<double>(begin: -0.05, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.isVisible) _controller.forward();
  }

  @override
  void didUpdateWidget(MainCard oldWidget) {
    super.didUpdateWidget(oldWidget);

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
              color: Colors.black.withAlpha(76),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color: Colors.white.withAlpha(76),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.child,
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
                onPressed: widget.onClose,
                icon: const Icon(Icons.close),
                label: const Text("إغلاق"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
