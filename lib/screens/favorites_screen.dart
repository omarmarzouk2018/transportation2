import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/route_provider.dart';
import '../services/storage_service.dart';
import '../models/route_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  String _formatRoute(RouteModel r) {
    return 'مسافة: ${(r.totalDistanceMeters / 1000).toStringAsFixed(2)} كم - ${(r.totalDurationSeconds / 60).round()} د';
  }

  @override
  Widget build(BuildContext context) {
    final rp = Provider.of<RouteProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('المسارات المفضلة')),
      body: ListView.builder(
        itemCount: rp.favorites.length,
        itemBuilder: (ctx, i) {
          final r = rp.favorites[i];
          return Dismissible(
            key: Key(r.id),
            background: Container(color: Colors.red),
            onDismissed: (d) async {
              await StorageService.instance.deleteFavoriteRoute(r.id);
              rp.loadFavorites();
            },
            child: ListTile(
              title: Text('المسار ${i + 1}'),
              subtitle: Text(_formatRoute(r)),
              onTap: () {
                rp.activeRoute = r;
                Navigator.of(context).pop();
              },
            ),
          );
        },
      ),
    );
  }
}
