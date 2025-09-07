import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/map_widget.dart';
import '../widgets/speed_display.dart';
import '../widgets/tracking_toggle.dart';
import '../widgets/route_details_panel.dart';
import '../providers/tracking_provider.dart';
import '../providers/route_provider.dart';
import '../providers/station_provider.dart';
import '../models/station_model.dart';
import '../widgets/station_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  StationProvider get _stationProvider =>
      Provider.of<StationProvider>(context, listen: false);

  void _onStationTap(StationModel station) {
    _stationProvider.selectStation(station);
  }

  void _closeCard() {
    _stationProvider.deselectStation();
  }

  Widget _buildStationCard() {
    return Consumer<StationProvider>(
      builder: (context, stationProvider, child) {
        final station = stationProvider.selectedStation;
        if (station == null) return const SizedBox.shrink();

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.8),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ),
                child: SizeTransition(
                  axis: Axis.vertical,
                  sizeFactor: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  ),
                  child: child,
                ),
              ),
            );
          },
          child: StationCard(
            key: ValueKey(station.id),
            station: station,
            isVisible: true,
            onClose: _closeCard,
            // onMarkerColorChange: _onMarkerColorChange,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

// @override
// void didChangeDependencies() {
//   super.didChangeDependencies();
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     final rp = Provider.of<RouteProvider>(context, listen: false);
//     rp.loadFavorites();
//   });
// }


  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {}

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
          MapWidget(
            onStationTap: _onStationTap,
            onMapTap: _closeCard,
          ),
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
          _buildStationCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // center map to current user location
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
