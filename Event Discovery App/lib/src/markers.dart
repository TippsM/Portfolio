import 'package:google_maps_flutter/google_maps_flutter.dart';

class Markers {
  Markers(this.markers);

  final Map<String, Marker> markers; // google map event location markers
}

class CachedMarkers {
  CachedMarkers();

  // what I do is map each cached marker set to a geohash as the key
  final Map<String, Markers> cachedMarkers = {};
}
