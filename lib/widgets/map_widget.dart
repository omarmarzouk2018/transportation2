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
import 'modal_bottom_sheet.dart';

class MapWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final tracking = context.watch<TrackingProvider>();
    final routeProv = context.watch<RouteProvider>();
    final stationProv = context.watch<StationProvider>();

    final center = initialCenter != null
        ? ll.LatLng(initialCenter!.latitude, initialCenter!.longitude)
        : (tracking.currentPosition != null
            ? ll.LatLng(
                tracking.currentPosition!.latitude,
                tracking.currentPosition!.longitude,
              )
            : const ll.LatLng(31.21564, 29.95527)); // إفتراضي: إسكندرية

    final tileLayer = MapService.instance.buildTileLayer(false);

    final markers = <Marker>[];
    if (tracking.currentPosition != null) {
      markers.add(
        MapService.instance.createUserMarker(tracking.currentPosition!),
      );
    }

    // الماركرات بتتبني من البروفايدر
    markers.addAll(
      MapService.instance.createStationMarkers(
        context,
        StationModel.stationsList,
        (station) {
          context.read<StationProvider>().selectStation(station);
          if (onStationTap != null) onStationTap!(station);
        },
        selectedStationId: stationProv.selectedStation?.id,
      ),
    );

    final polylines = <Polyline>[];
    if (routeProv.activeRoute != null) {
      for (final leg in routeProv.activeRoute!.legs) {
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
      mapController: MapController(),
      options: MapOptions(
        initialCenter: center,
        initialZoom: initialZoom,
        minZoom: 13.5,
        maxZoom: 20,
        onTap: (tapPos, latlng) {
          if (onMapTap != null) onMapTap!();

          if (allowDestinationTap) {
            final dest = LatLng(latlng.latitude, latlng.longitude);

            // إلغاء تحديد المحطة
            context.read<StationProvider>().clearStation();

            showModalBottomSheet(
              context: context,
              builder: (_) => ModalBottomSheet(
                routeProv: routeProv,
                dest: dest,
              ),
            );
          }
        },
      ),
      children: [
        tileLayer,
        if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
