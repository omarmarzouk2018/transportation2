import 'package:alex_transit/widgets/station_marker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../models/lat_lng.dart' as model;
import '../models/station_model.dart';
import '../models/route_model.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import '../providers/tracking_provider.dart';
import '../services/dimensions.dart';
import 'package:provider/provider.dart';
import '../providers/route_provider.dart';
import 'package:http/io_client.dart';

class MapService {
  MapService._privateConstructor();
  static final MapService instance = MapService._privateConstructor();

  final String api_key = '32f44222-373c-47ef-bd43-a09409ab0487';

  /// Map controller (singleton)
  final MapController mapController = MapController();

  // create one time here avoid rebuild at every build
  final FMTCTileProvider _tileProvider = FMTCTileProvider.new(
      stores: {
        'mapStore': BrowseStoreStrategy.readUpdateCreate,
      },
      loadingStrategy: BrowseLoadingStrategy.cacheFirst,
      recordHitsAndMisses: true,
      cachedValidDuration: const Duration(days: 30),
      httpClient: IOClient());

  TileLayer buildTileLayer(bool nightMode) {
    return TileLayer(
      urlTemplate: nightMode
          // ? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
          // : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          // note that we need to edit the link to enable the night mode tiles
          ? 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png?api_key=$api_key'
          : 'https://tiles.stadiamaps.com/tiles/alidade_satellite/{z}/{x}/{y}{r}.png?api_key=$api_key',
      // subdomains: const ['a', 'b', 'c'],
      userAgentPackageName: 'com.example.app',
      tileProvider: _tileProvider,
    );
  }

  Marker createUserMarker(BuildContext context) {
    final trackingProvider = context.watch<TrackingProvider>();
    final position = trackingProvider.currentPosition;
    if (position == null) {
      if (position == null)
        return Marker(
            point: ll.LatLng(0, 0),
            width: 0,
            height: 0,
            child: const SizedBox.shrink());
    }
    return Marker(
      point: ll.LatLng(position.latitude, position.longitude),
      width: AppDimensions.userMarkerWidth,
      height: AppDimensions.userMarkerHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.my_location, size: 36, color: Colors.blue),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'أنت',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Marker createDestinationMarker(BuildContext context) {
    final _routeProvider = context.read<RouteProvider>();
    final position = _routeProvider.destination!;
    return Marker(
      point: ll.LatLng(position.latitude, position.longitude),
      width: AppDimensions.userMarkerWidth,
      height: AppDimensions.userMarkerHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.location_on, size: 36, color: Colors.red),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(50),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'الوجهة',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Marker> createStationMarkers(
      BuildContext context, List<StationModel> stations) {
    // this function updates `selectedStationId` from the parent widget.
    // When this value changes, the marker will be rebuilt,
    // causing a new value to be passed to `isSelected` in `StationMarkerWidget`.
    // This change is what drives the update animation inside `StationMarkerWidget`.
    return stations.map((station) {
      return Marker(
        width: AppDimensions.stationMarkerWidth,
        height: AppDimensions.stationMarkerHeight,
        point: ll.LatLng(station.location.latitude, station.location.longitude),
        child: StationMarkerWidget(
          station: station,
        ),
      );
    }).toList();
  }

  LatLngBounds computeBoundsForRoute(RouteModel route) {
    final points = <ll.LatLng>[];
    for (final leg in route.legs) {
      for (final p in leg.geometry) {
        points.add(ll.LatLng(p.latitude, p.longitude));
      }
    }
    if (points.isEmpty) {
      final o = ll.LatLng(route.origin.latitude, route.origin.longitude);
      return LatLngBounds(o, o);
    }
    final latitudes = points.map((p) => p.latitude).toList();
    final longitudes = points.map((p) => p.longitude).toList();
    final sw = ll.LatLng(
      latitudes.reduce((a, b) => a < b ? a : b),
      longitudes.reduce((a, b) => a < b ? a : b),
    );
    final ne = ll.LatLng(
      latitudes.reduce((a, b) => a > b ? a : b),
      longitudes.reduce((a, b) => a > b ? a : b),
    );
    return LatLngBounds(sw, ne);
  }

  /// Moves map to a specific LatLng with zoom
  void moveToPosition(
      BuildContext context, model.LatLng? position, double zoom) {
    if (position != null) {
      mapController.move(
          ll.LatLng(position.latitude, position.longitude), zoom);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الموقع الحالي غير متوفر')),
      );
    }
  }
}

class MapUtils {
  static Future<TileLayer> toggleNightMode(bool nightMode) async {
    // placeholder for saving setting
    return MapService.instance.buildTileLayer(nightMode);
  }
}
