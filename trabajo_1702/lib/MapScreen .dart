import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Asegúrate de importar Hive Flutter
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'Screens/taskMate/models/task_model.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Ubicación no disponible');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permisos de ubicación denegados permanentemente');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        throw Exception('Permisos de ubicación no concedidos');
      }
    }

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Actualización cada 10 metros
    );

    return await Geolocator.getCurrentPosition(locationSettings: locationSettings);
  }

  @override
  Widget build(BuildContext context) {
    final taskBox = Hive.box<Task>('tasks'); // Solo accedemos a la caja abierta en main.dart

    return Scaffold(
      appBar: AppBar(title: const Text("Mapa de Tareas")),
      body: FutureBuilder<Position>(
        future: _getCurrentLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          Position position = snapshot.data!;

          var markers = taskBox.values
              .where((task) => task.latitude != null)
              .map((task) => Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(task.latitude!, task.longitude!),
                    builder: (ctx) => const Icon(Icons.location_on, color: Colors.blue),
                  ))
              .toList();

          return FlutterMap(
            options: MapOptions(
              center: LatLng(position.latitude, position.longitude),
              zoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: markers,
              ),
            ],
          );
        },
      ),
    );
  }
}
