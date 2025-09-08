import 'package:alex_transit/services/map_service.dart';
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
import '../widgets/route_card.dart';

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

  Widget _buildSlidingCard(Widget child) {
    if (child == null) return const SizedBox.shrink();
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
      child: child,
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
    final _routeProvider = Provider.of<RouteProvider>(context);
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
          ),
          Positioned(top: 12, left: 12, child: SpeedDisplay()),
          Positioned(top: 12, right: 12, child: TrackingToggle()),
          if (_routeProvider.activeRoute != null)
            Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: RouteDetailsPanel(route: _routeProvider.activeRoute!)),
          Consumer<StationProvider>(builder: (context, sp, _) {
            final station = sp.selectedStation;
            if (station == null) return const SizedBox.shrink();

            return _buildSlidingCard(StationCard(
              key: ValueKey(station.id),
              station: station,
              isVisible: true,
              onClose: _closeCard,
            ));
          }),
          if (_routeProvider.destination != null)
            _buildSlidingCard(RouteCard(
              dest: _routeProvider.destination!,
            ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MapService.instance.moveToPosition(context, tp.currentPosition, 15.0);
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
