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
import 'modal_bottom_sheet.dart';
// import '../data/stations_repository.dart';

class MapWidget extends StatefulWidget {
  final LatLng? initialCenter;
  final double initialZoom;
  final bool allowDestinationTap;
  final void Function(StationModel)? onStationTap;
  final VoidCallback? onMapTap;

  const MapWidget({
    Key? key,
    this.initialCenter,
    this.initialZoom = 14.0,
    this.allowDestinationTap = true,
    this.onStationTap,
    this.onMapTap,
  }) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController _controller = MapController();
  bool nightMode = false;
  List<Marker> stationMarkers = [];
  String? selectedStationId;

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  void _loadStations({String? selectedId}) {
    setState(() {
      stationMarkers = MapService.instance.createStationMarkers(
        StationModel.stationsList,
        _onStationTap,
        selectedStationId: selectedId ?? selectedStationId,
      );
    });
  }

  void _onStationTap(StationModel station) {
    _loadStations(selectedId: station.id);
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
          onTap: (tapPos, latlng) {
            if (widget.onMapTap != null) {
              widget.onMapTap!();
            }
            if (widget.allowDestinationTap) {
              final dest = LatLng(latlng.latitude, latlng.longitude);
              setState(() {
                selectedStationId = null; // Deselect station on map tap
                _loadStations(selectedId: null);
              });
              showModalBottomSheet(
                context: context,
                builder: (_) {
                  return ModalBottomSheet(routeProv: routeProv, dest: dest);
                },
              );
            }
          }),
      children: [
        tileLayer,
        if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
