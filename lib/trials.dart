void _onStationTap(StationModel station) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // يخلي الـ sheet ياخد مساحة مرنة
    backgroundColor: Colors.transparent, // شفاف للخلفية
    barrierColor: Colors.transparent, // يخلي الخريطة تفضل شغالة
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.25, // يبدأ بربع الشاشة
        minChildSize: 0.2, // أقل حاجة
        maxChildSize: 0.8, // أكبر حاجة
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
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Text(
                      station.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('نوع المحطة: ${station.type.text}',
                        style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      label: const Text("إغلاق"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

// dart run trials.dart
// flutter run -t lib/trials.dart
