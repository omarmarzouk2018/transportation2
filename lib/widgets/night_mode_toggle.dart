import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class NightModeToggle extends StatefulWidget {
  final bool isNightMode;
  final ValueChanged<bool> onToggle;

  const NightModeToggle({Key? key, required this.isNightMode, required this.onToggle}) : super(key: key);

  @override
  State<NightModeToggle> createState() => _NightModeToggleState();
}

class _NightModeToggleState extends State<NightModeToggle> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.isNightMode;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('وضع ليلي'),
        Switch(
          value: value,
          onChanged: (v) async {
            setState(() => value = v);
            await StorageService.instance.setSetting('night_mode', v);
            widget.onToggle(v);
          },
        ),
      ],
    );
  }
}
