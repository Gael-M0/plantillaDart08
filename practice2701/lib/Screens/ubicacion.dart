import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationExample extends StatefulWidget {
  const LocationExample({super.key});

  @override
  _LocationExampleState createState() => _LocationExampleState();
}

class _LocationExampleState extends State<LocationExample> {
  String _location = "Ubicación desconocida";

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Comprobar si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _location = "Los servicios de ubicación están deshabilitados.";
      });
      return;
    }

    // Verificar permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _location = "Los permisos de ubicación fueron denegados.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _location = "Los permisos de ubicación están permanentemente denegados.";
      });
      return;
    }

    // Obtener la ubicación actual
    Position position = await Geolocator.getCurrentPosition(
        //desiredAccuracy: LocationAccuracy.high
         locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ),
        );
    setState(() {
      _location =
          "Latitud: ${position.latitude}, Longitud: ${position.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ubicación Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_location),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getLocation,
              child: const Text("Obtener Ubicación"),
            ),
          ],
        ),
      ),
    );
  }
}
