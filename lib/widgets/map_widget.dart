import 'package:alex_transit/widgets/station_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:provider/provider.dart';
import '../models/lat_lng.dart';
import '../models/leg_model.dart'; // where LegType is defined
import '../models/station_model.dart'; // where StationModel is defined
import '../services/map_service.dart';
import '../providers/tracking_provider.dart';
import '../providers/route_provider.dart';
import '../widgets/draged_bottom_sheet.dart';
import '../widgets/station_card.dart';
// import '../data/stations_repository.dart';

class MapWidget extends StatefulWidget {
  final LatLng? initialCenter;
  final double initialZoom;
  final bool allowDestinationTap;
  final void Function(StationModel)? onStationTap;

  const MapWidget({
    Key? key,
    this.initialCenter,
    this.initialZoom = 14.0,
    this.allowDestinationTap = true,
    this.onStationTap,
  }) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

String? selectedStationId;

class _MapWidgetState extends State<MapWidget> {
  final MapController _controller = MapController();
  bool nightMode = false;
  List<Marker> stationMarkers = [];

  @override
  void initState() {
    super.initState();
    _updateMarkers();
    widget.onStationTap;
  }

  void _updateMarkers({String? selectedId}) {
    setState(() {
      selectedStationId = selectedId ?? selectedStationId;
      stationMarkers = MapService.instance.createStationMarkers(
        StationModel.stationsList,
        _onStationTap,
        selectedStationId: selectedStationId,
      );
    });
  }

  void _onStationTap(StationModel station) {
    _updateMarkers(selectedId: station.id);
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   barrierColor: Colors.transparent,
    //   useSafeArea: true,
    //   builder: (_) {
    //     return DragedBottomSheet(station: station);
    //   },
    // );
    // Handle card tap
    if (widget.onStationTap != null) {
      widget.onStationTap!(station);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracking = Provider.of<TrackingProvider>(context);
    final routeProv = Provider.of<RouteProvider>(context);

    final center = widget.initialCenter != null
        ? ll.LatLng(
            widget.initialCenter!.latitude,
            widget.initialCenter!.longitude,
          )
        : (tracking.currentPosition != null
            ? ll.LatLng(
                tracking.currentPosition!.latitude,
                tracking.currentPosition!.longitude,
              )
            : const ll.LatLng(31.21564, 29.95527)); // إفتراضي: إسكندرية

    final tileLayer = MapService.instance.buildTileLayer(nightMode);

    final markers = <Marker>[];
    if (tracking.currentPosition != null) {
      markers
          .add(MapService.instance.createUserMarker(tracking.currentPosition!));
    }
    markers.addAll(stationMarkers);

    final polylines = <Polyline>[];
    if (routeProv.activeRoute != null) {
      for (final leg in routeProv.activeRoute!.legs) {
        final color = leg.type == LegType.transit
            ? Colors.red
            : (leg.type == LegType.walk_to ? Colors.blue : Colors.green);

        // leg.points لازم تكون List<ll.LatLng> أو List<LatLng> من latlong2
        polylines.add(
          Polyline(
            points: leg.geometry
                .map((p) => ll.LatLng(p.latitude, p.longitude))
                .toList(),
            strokeWidth: leg.type == LegType.transit ? 5 : 4,
            color: color,
          ),
        );
      }
    }

    return FlutterMap(
      mapController: _controller,
      options: MapOptions(
        initialCenter: center,
        initialZoom: widget.initialZoom,
        minZoom: 13.5,
        maxZoom: 20,
        onTap: widget.allowDestinationTap
            ? (tapPos, latlng) {
                final dest = LatLng(latlng.latitude, latlng.longitude);
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'اذهب إلى هذا المكان',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              routeProv.calculateAndSetRoute(dest);
                              Navigator.of(context).pop();
                            },
                            child: const Text('تأكيد'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            : null,
      ),
      children: [
        tileLayer,
        if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
