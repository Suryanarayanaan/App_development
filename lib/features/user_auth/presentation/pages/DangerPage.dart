import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DangerPage extends StatefulWidget {
  @override
  _DangerPageState createState() => _DangerPageState();
}

class _DangerPageState extends State<DangerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Danger zones',
          style: TextStyle(fontSize: 22),
        ),
        backgroundColor: Color(0xFF646ADA), // Text
      ), // AppBar
      body: content(),
    ); // Scaffold
  }

  Widget content() {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(13.026370, 80.221880),
        zoom: 11,
        interactiveFlags: InteractiveFlag.all,
      ), // MapOptions
      children: [
        openStreetMapTileLayer,
        CircleLayer(circles: [
          CircleMarker(
            point: LatLng(13.010330, 80.231812),
            color: Colors.red.withOpacity(0.5), // Red transparent circle
            radius: 15, // Adjust radius as needed
          ),
          CircleMarker(
            point: LatLng(13.018031, 80.241096),
            color: Colors.red.withOpacity(0.5), // Red transparent circle
            radius: 15, // Adjust radius as needed
          ),
          CircleMarker(
            point: LatLng(12.98177, 80.21994),
            color: Colors.red.withOpacity(0.5), // Red transparent circle
            radius: 15, // Adjust radius as needed
          ),
          CircleMarker(
            point: LatLng(12.97105, 80.20076),
            color: Colors.red.withOpacity(0.5), // Red transparent circle
            radius: 15, // Adjust radius as needed
          ),
          CircleMarker(
            point: LatLng(12.98202, 80.23201),
            color: Colors.red.withOpacity(0.5), // Red transparent circle
            radius: 15, // Adjust radius as needed
          ),
          CircleMarker(
            point: LatLng(13.01600, 80.25872),
            color: Colors.red.withOpacity(0.5), // Red transparent circle
            radius: 15, // Adjust radius as needed
          ),
          CircleMarker(
            point: LatLng(13.01622, 80.27125),
            color: Colors.red.withOpacity(0.5), // Red transparent circle
            radius: 15, // Adjust radius as needed
          ),
          CircleMarker(
            point: LatLng(13.06660, 80.23300),
            color: Colors.red.withOpacity(0.5), // Red transparent circle
            radius: 15, // Adjust radius as needed
          ),
          CircleMarker(
            point: LatLng(13.07688, 80.17518),
            color: Colors.red.withOpacity(0.5), // Red transparent circle
            radius: 15, // Adjust radius as needed
          ),
          CircleMarker(
            point: LatLng(13.07694, 80.18963),
            color: Colors.red.withOpacity(0.5), // Red transparent circle
            radius: 15, // Adjust radius as needed
          ),
          CircleMarker(
            point: LatLng(13.03208, 80.15579),
            color: Colors.red.withOpacity(0.5), // Red transparent circle
            radius: 15, // Adjust radius as needed
          ),
        ]),
      ],
    ); // FlutterMap
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
