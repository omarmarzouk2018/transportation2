import 'package:alex_transit/config/app_config.dart';
import 'package:alex_transit/data/line_segment_data.dart';
import 'package:alex_transit/models/line_segment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:provider/provider.dart';
import '../data/stations_data.dart';
import '../models/lat_lng.dart';
import '../models/leg_model.dart'; // where LegType is defined
import '../models/station_model.dart'; // where StationModel is defined
import '../services/map_service.dart';
import '../providers/tracking_provider.dart';
import '../providers/route_provider.dart';
import '../providers/station_provider.dart';
import 'route_card.dart';
import '../services/ors_service.dart';

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

Marker? _destinationMarker;

class _MapWidgetState extends State<MapWidget> {
  List<ll.LatLng> routePoints = [];

  @override
  Widget build(BuildContext context) {
    final trackingProv = context.read<TrackingProvider>();
    final _routeProvider = context.read<RouteProvider>();
    final _stationProvider = context.read<StationProvider>();

    final tileLayer = MapService.instance.buildTileLayer(false);

    // list of markers to be displayed on the map
    final markers = <Marker>[];

    // user marker
    if (trackingProv.currentPosition != null) {
      markers.add(
        MapService.instance.createUserMarker(context),
      );
    }

    // stations markers - using provider to get stations
    markers.addAll(
      MapService.instance.createStationMarkers(
        context,
        _stationProvider.stations,
      ),
    );

    // map centre user location or alex centre
    final center = trackingProv.currentPosition != null
        ? ll.LatLng(
            trackingProv.currentPosition!.latitude,
            trackingProv.currentPosition!.longitude,
          )
        : const ll.LatLng(31.21564, 29.95527); // alex by default

    // if (_routeProvider.activeRoute != null) {
    // for (final leg in _routeProvider.activeRoute!.legs) {
    // final color = leg.type == LegType.transit
    //     ? Colors.red
    //     : (leg.type == LegType.walk_to ? Colors.blue : Colors.green);

    // polylines.add(
    //   Polyline(
    //     points: leg.geometry
    //         .map((p) => ll.LatLng(p.latitude, p.longitude))
    //         .toList(),
    //     strokeWidth: leg.type == LegType.transit ? 5 : 4,
    //     color: color,
    //   ),
    // );
    // }
    // }

    Future<void> _loadRoute() async {
      final start = [
        StationsData.sidiGaber.location.longitude,
        StationsData.sidiGaber.location.latitude,
      ]; // [lng, lat]
      final end = [
        StationsData.egyptStation.location.longitude,
        StationsData.egyptStation.location.latitude,
      ]; // [lng, lat]

      final coords = await getRouteFromORS(start: start, end: end);
      // coords = [[lat, lng], [lat, lng], ...]

      setState(() {
        // coords = [[lat, lng], [lat, lng] ...]
        routePoints = coords.map((c) => ll.LatLng(c[0], c[1])).toList();
      });
    }

    // _loadRoute();

    final polylines = LineSegmentData.segments.map((segment) {
      return Polyline(
        points: segment.coordinations,
        strokeWidth: 2,
        color: Colors.red,
      );
    }).toList();

    return FlutterMap(
      mapController: MapService.instance.mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: widget.initialZoom,
        minZoom: 13.5,
        maxZoom: 20,
        onTap: (tapPos, latlng) {
          _stationProvider.deselectStation();

          _routeProvider
              .setDestination(LatLng(latlng.latitude, latlng.longitude));
          // _loadRoute();

          if (_routeProvider.destination != null) {
            _destinationMarker =
                MapService.instance.createDestinationMarker(context);
          }
        },
      ),
      children: [
        tileLayer,
        PolylineLayer(polylines: [
          if (routePoints.isNotEmpty)
            Polyline(
              points: routePoints,
              strokeWidth: 1,
              color: Colors.blue,
            ),
          if (polylines.isNotEmpty) ...polylines
        ]),
        Consumer<RouteProvider>(
          builder: (context, rp, _) {
            return MarkerLayer(markers: [
              ...markers,
              if (rp.destination != null) _destinationMarker!
            ]);
          },
        ),
      ],
    );
  }
}
