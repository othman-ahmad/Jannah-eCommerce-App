import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Simple result bundle returned when the user confirms a location.
/// [addressLine], [city], [state], [country], [postalCode] are best-effort
/// results from reverse geocoding — they may be empty if the lookup fails
/// or returns nothing, so the caller should treat them as suggestions,
/// not guaranteed values.
class PickedLocation {
  final double latitude;
  final double longitude;
  final String addressLine;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  const PickedLocation({
    required this.latitude,
    required this.longitude,
    this.addressLine = '',
    this.city = '',
    this.state = '',
    this.country = '',
    this.postalCode = '',
  });
}

class LocationPickerScreen extends StatefulWidget {
  /// Optional starting point (e.g. the address being edited). Falls back
  /// to [_defaultCenter] if null.
  final LatLng? initialLatLng;

  const LocationPickerScreen({super.key, this.initialLatLng});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  // Amman, Jordan — swap for whatever makes sense as a sane default.
  static const LatLng _defaultCenter = LatLng(31.9539, 35.9106);

  final MapController _mapController = MapController();
  late LatLng _currentCenter;
  bool _isMoving = false;
  bool _isResolving = false;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _currentCenter = widget.initialLatLng ?? _defaultCenter;
  }

  static const String _locationIqApiKey = 'pk.db21b1b91f7797f85f08957faddacea5';

  Future<void> _useCurrentLocation() async {
    if (_isLocating) return;
    setState(() => _isLocating = true);

    try {
      // 1. Is location even turned on for the device?
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationMessage(
          'Location services are turned off. Enable them in your device settings.',
        );
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationMessage('Location permission was denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationMessage(
          'Location permission is permanently denied. Enable it from app settings.',
        );
        return;
      }

      // 3. We're clear — get the position and recenter the map on it.
      final position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 10));

      final target = LatLng(position.latitude, position.longitude);
      _currentCenter = target;
      _mapController.move(target, _mapController.camera.zoom);
    } catch (e) {
      debugPrint('Current location error: $e');
      _showLocationMessage('Could not get your current location.');
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _showLocationMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Reverse geocodes via LocationIQ. Unlike the public Nominatim endpoint,
  /// this is actually intended for use inside shipped apps.
  Future<void> _confirm() async {
    setState(() => _isResolving = true);

    String addressLine = '';
    String city = '';
    String state = '';
    String country = '';
    String postalCode = '';

    try {
      final uri = Uri.https('us1.locationiq.com', '/v1/reverse', {
        'key': _locationIqApiKey,
        'lat': _currentCenter.latitude.toString(),
        'lon': _currentCenter.longitude.toString(),
        'format': 'json',
        'addressdetails': '1',
      });

      final response = await http.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final addr = data['address'] as Map<String, dynamic>? ?? {};

        final road = addr['road'] as String?;
        final houseNumber = addr['house_number'] as String?;
        addressLine = [
          houseNumber,
          road,
        ].where((e) => e != null && e.trim().isNotEmpty).join(' ');

        city =
            (addr['city'] ?? addr['town'] ?? addr['village'] ?? '') as String;
        state = (addr['state'] ?? '') as String;
        country = (addr['country'] ?? '') as String;
        postalCode = (addr['postcode'] ?? '') as String;

        if (city.isEmpty && country.isEmpty) {
          // Got a 200 but no usable address block — usually means the
          // point is somewhere with sparse map data (open water, remote
          // area). Not a bug, just nothing to show.
          debugPrint('Reverse geocode: empty address for $_currentCenter');
        }
      } else {
        // Surface this instead of hiding it. A 401/403 almost always means
        // the API key below is still the placeholder or invalid; a 429
        // means you've hit the free-tier rate limit.
        debugPrint(
          'Reverse geocode failed: HTTP ${response.statusCode} — ${response.body}',
        );
      }
    } catch (e) {
      // Reverse geocoding is a convenience, not a requirement — if it fails
      // we still return coordinates. But log it so it's diagnosable instead
      // of silently vanishing.
      debugPrint('Reverse geocode error: $e');
    }

    if (!mounted) return;

    Navigator.of(context).pop(
      PickedLocation(
        latitude: _currentCenter.latitude,
        longitude: _currentCenter.longitude,
        addressLine: addressLine,
        city: city,
        state: state,
        country: country,
        postalCode: postalCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Choose Location',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: 15,
              onPositionChanged: (camera, hasGesture) {
                _currentCenter = camera.center;
                if (hasGesture && !_isMoving) {
                  setState(() => _isMoving = true);
                } else if (!hasGesture && _isMoving) {
                  setState(() => _isMoving = false);
                }
              },
            ),
            children: [
              TileLayer(
                // Standard OSM tile server. For production apps with real
                // traffic, review OSM's tile usage policy and consider a
                // dedicated provider (MapTiler, Stadia Maps, etc. all have
                // free tiers too) instead of hammering the public server.
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.jannah.app',
              ),
              // Required: OSM's tile usage terms require visible attribution
              // on the map itself, and LocationIQ's free-tier terms require
              // crediting them somewhere in the app — this satisfies both
              // in one place.
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    '© OpenStreetMap contributors',
                    onTap: () {},
                  ),
                  TextSourceAttribution(
                    'Geocoding by LocationIQ',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),

          // Fixed pin in the center of the screen. The map moves under it;
          // whatever coordinate sits under the pin tip is what gets saved.
          IgnorePointer(
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 120),
              padding: EdgeInsets.only(bottom: _isMoving ? 8 : 0),
              child: const Icon(
                Icons.location_on,
                size: 44,
                color: Colors.black,
              ),
            ),
          ),

          // "Use my current location" button, sitting just above the
          // confirm bar so it doesn't compete with it for thumb reach.
          Positioned(
            right: 16,
            bottom: 92,
            child: SafeArea(
              top: false,
              child: FloatingActionButton(
                heroTag: 'use_current_location',
                onPressed: _isLocating ? null : _useCurrentLocation,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 3,
                child: _isLocating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
              ),
            ),
          ),

          // Bottom confirm bar.
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 54,
                child: FilledButton(
                  onPressed: _isResolving ? null : _confirm,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isResolving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Confirm Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
