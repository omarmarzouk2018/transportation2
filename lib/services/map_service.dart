import 'package:alex_transit/widgets/station_marker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../models/lat_lng.dart' as model;
import '../models/station_model.dart';
import '../models/route_model.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import '../services/dimensions.dart';

class MapService {
  MapService._privateConstructor();
  static final MapService instance = MapService._privateConstructor();

  final String api_key = '32f44222-373c-47ef-bd43-a09409ab0487';
  // create one time here avoid rebuild at every build
  final FMTCTileProvider _tileProvider = FMTCTileProvider.new(
    stores: {
      'mapStore': BrowseStoreStrategy.readUpdateCreate,
    },
    loadingStrategy: BrowseLoadingStrategy.cacheFirst,
    recordHitsAndMisses: true,
    cachedValidDuration: const Duration(days: 30),
  );

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

  Marker createUserMarker(model.LatLng position) {
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

  List<Marker> createStationMarkers(
      List<StationModel> stations, void Function(StationModel) onTap,
      {String? selectedStationId}) {
    // هذه الدالة تعتمد على تحديث `selectedStationId` من الـ Widget الأب.
    // عند تغيير هذه القيمة، سيتم إعادة بناء الـ Marker،
    // مما يؤدي إلى تمرير قيمة جديدة لـ `isSelected` إلى `StationMarkerWidget`.
    // هذا التغيير هو ما يشغل حركة التحديث داخل `StationMarkerWidget`.

    return stations.map((station) {
      return Marker(
        width: AppDimensions.stationMarkerWidth,
        height: AppDimensions.stationMarkerHeight,
        point: ll.LatLng(station.location.latitude, station.location.longitude),
        child: StationMarkerWidget(
          station: station,
          onTap: () => onTap(station),
          isSelected: selectedStationId == station.id,
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
}

class MapUtils {
  static Future<TileLayer> toggleNightMode(bool nightMode) async {
    // placeholder for saving setting
    return MapService.instance.buildTileLayer(nightMode);
  }
}
