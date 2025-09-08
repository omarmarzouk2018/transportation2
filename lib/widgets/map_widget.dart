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
import '../providers/station_provider.dart';
import 'route_card.dart';

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

    final polylines = <Polyline>[];
    if (_routeProvider.activeRoute != null) {
      for (final leg in _routeProvider.activeRoute!.legs) {
        final color = leg.type == LegType.transit
            ? Colors.red
            : (leg.type == LegType.walk_to ? Colors.blue : Colors.green);

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

          setState(() {
            _destinationMarker =
                MapService.instance.createDestinationMarker(context);
          });
        },
      ),
      children: [
        tileLayer,
        if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
        MarkerLayer(markers: [
          ...markers,
          if (_destinationMarker != null) _destinationMarker!
        ]),
      ],
    );
  }
}
