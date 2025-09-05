import 'package:flutter/material.dart';
import '../models/station_model.dart';

class StationCard extends StatefulWidget {
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
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<StationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );

    // تعريف تسلسل للحركة لجعلها أكثر طبيعية
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, // منحنى مرن يعطي إحساساً بالارتداد اللطيف
    );

    _scaleAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
            .animate(curvedAnimation);
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation);

    // تشغيل الحركة عند ظهور الودجت
    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(StationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // مراقبة تغير الخاصية isVisible وتشغيل الحركة بناءً عليها
    if (widget.isVisible && !oldWidget.isVisible) {
      _controller.forward();
    } else if (!widget.isVisible && oldWidget.isVisible) {
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
    // إذا لم يكن الكارد مرئياً، لا تعرض أي شيء
    if (!widget.isVisible && _controller.status == AnimationStatus.dismissed) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Material(
              elevation: 12, // زيادة الظل قليلاً لبروز أكبر
              borderRadius: BorderRadius.circular(20), // زيادة استدارة الزوايا
              color: Colors.transparent, // جعل الخلفية شفافة لتطبيق التدرج
              child: Container(
                width: 220, // زيادة العرض قليلاً
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // إضافة تدرج لوني بدلاً من لون واحد
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.lightBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  // إضافة ظل داخلي لإعطاء عمق أكبر
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.station.name,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "نوع المحطة: ${widget.station.type.text}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    // تحسين زر الإغلاق
                    ElevatedButton.icon(
                      onPressed: widget.onClose,
                      icon: const Icon(Icons.close, color: Colors.blueAccent),
                      label: const Text("إغلاق"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
