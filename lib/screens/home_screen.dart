import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/map_widget.dart';
import '../widgets/speed_display.dart';
import '../widgets/tracking_toggle.dart';
import '../widgets/route_details_panel.dart';
import '../providers/tracking_provider.dart';
import '../providers/route_provider.dart';
import '../models/station_model.dart';
import '../widgets/station_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  StationModel? selectedStation;

  void _onStationTap(StationModel station) {
    setState(() {
      selectedStation = station;
    });
  }

  void _closeCard() {
    setState(() {
      selectedStation = null;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final rp = Provider.of<RouteProvider>(context, listen: false);
    rp.loadFavorites();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // final tp = Provider.of<TrackingProvider>(context, listen: false);
    if (state == AppLifecycleState.paused) {
      // preserve state
    } else if (state == AppLifecycleState.resumed) {
      // resume if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final tp = Provider.of<TrackingProvider>(context);
    final rp = Provider.of<RouteProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('خريطة الإسكندرية'),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).pushNamed('/favorites'),
              icon: const Icon(Icons.favorite)),
          IconButton(
              onPressed: () => Navigator.of(context).pushNamed('/settings'),
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: Stack(
        children: [
          MapWidget(onStationTap: _onStationTap, onMapTap: _closeCard),
          Positioned(
              top: 12,
              left: 12,
              child: SpeedDisplay(
                  speedMps: tp.currentSpeedMps, mode: tp.currentMode)),
          Positioned(
              top: 12,
              right: 12,
              child: TrackingToggle(
                  isTracking: tp.isTracking, onToggle: tp.toggle)),
          if (rp.activeRoute != null)
            Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: RouteDetailsPanel(route: rp.activeRoute!)),
          if (selectedStation != null)
            StationCard(
              station: selectedStation!,
              isVisible: true,
              onClose: () => setState(() => selectedStation = null),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // center map to current user location - omitted for brevity
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
