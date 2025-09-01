import 'package:flutter/material.dart';
import '../widgets/night_mode_toggle.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool nightMode = false;

  @override
  void initState() {
    super.initState();
    final val = StorageService.instance.getSetting('night_mode');
    nightMode = val == true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          NightModeToggle(isNightMode: nightMode, onToggle: (v) {
            setState(() => nightMode = v);
          },),
          const SizedBox(height: 12),
          const ListTile(
            title: Text('API Keys'),
            subtitle: Text('قم بتعيين ORS_API_KEY في env أو CI'),
          ),
          const SizedBox(height: 12),
          const ListTile(
            title: Text('Notifications'),
            subtitle: Text('تفعيل/إيقاف إشعارات الوصول'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
              onPressed: () async {
                await StorageService.instance.setSetting('traffic_collection', false);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث الإعداد')));
              },
              child: const Text('مسح عينات المرور'),),
        ],
      ),
    );
  }
}
