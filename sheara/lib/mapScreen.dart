import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../database/accountsDatabase.dart';
import '../model/account.dart';

class MapScreen extends StatefulWidget {
  @override
  final account currentUser;
  MapScreen({required this.currentUser});

  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;
  late LocationData _currentLocation;
  double _zoomLevel = 16;
  late Location _location;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _location = Location();
    _currentLocation = LocationData.fromMap({'latitude': 10.640960, 'longitude': 122.237747});

    _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentLocation = locationData;
      });
    });
  }

  void _zoomIn() {
    double currentZoom = _mapController.zoom;
    _mapController.move(LatLng(_currentLocation.latitude!, _currentLocation.longitude!), currentZoom + 0.5);
  }

  void _zoomOut() {
    double currentZoom = _mapController.zoom;
    _mapController.move(LatLng(_currentLocation.latitude!, _currentLocation.longitude!), currentZoom - 0.5);
  }

  void _centerOnMarker() {
    _mapController.move(LatLng(_currentLocation.latitude!, _currentLocation.longitude!), _zoomLevel);
  }

  void _toggleHelpStatus() async {
    bool newHelpStatus = !widget.currentUser.needsHelp;
    widget.currentUser.needsHelp = newHelpStatus;

    try {
      await accountsDatabase.instance.update(widget.currentUser);
      setState(() {
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Help status updated successfully!'),
      ));
    } catch (e) {
      print('Error updating help status: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update help status. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _zoomIn,
            child: Icon(Icons.add),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _zoomOut,
            child: Icon(Icons.remove),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _centerOnMarker,
            child: Icon(Icons.my_location),
          ),
          FloatingActionButton(
            onPressed: _toggleHelpStatus,
            child: Icon(Icons.help),
          )
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
              zoom: _zoomLevel,
              minZoom: 10.0,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                // urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                urlTemplate: 'https://tile-{s}.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                // urlTemplate: 'http://tile.stamen.com/terrain/{z}/{x}/{y}.jpg',
                // urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                // urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 40.0,
                    height: 40.0,
                    point: LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
                    child: Icon(
                        Icons.location_pin,
                        color: Colors.red,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
