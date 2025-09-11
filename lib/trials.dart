import 'package:flutter/material.dart';
import 'services/ors_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const apiKey = "حط-مفتاح-ORS-هنا";

  final start = [29.9187, 31.2001]; // [lng, lat]
  final end = [29.9387, 31.2201];   // [lng, lat]

  try {
    final route = await getRouteFromORS(
      apiKey: apiKey,
      start: start,
      end: end,
    );

    print("Route points: $route");
  } catch (e) {
    print("Error: $e");
  }
}
