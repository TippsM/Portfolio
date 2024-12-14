import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo_coder;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get_it/get_it.dart';

import 'src/events.dart' as events;
import 'src/markers.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Map<String, Marker> _markers = {}; // google map event location markers
  Map<String, LatLng> latlng =
      {}; // populated if no event location lat/lng fields exist and we must work with an address instead

  late Future<events.Response> localEventsFuture;
  @override
  void initState() {
    super.initState();
    try {
      localEventsFuture = fetchEvents();
    } catch (e) {
      // ignore: discarded_futures
      _showRequestError(e.toString());
    }
  }

  Future<events.Response> fetchEvents() {
    return GetIt.instance<events.CachedEvents>()
        .fetchEventsFromDeviceLocation(size: 200, radius: 100);
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final localEvents = await localEventsFuture;
    final getIt = GetIt.instance;
    String? geoHash = getIt<events.CachedEvents>().geoHash;

    // checks each event to see if it doesn't have a lat lng pair but does have an address, and finds a lat lng pair.
    // also checks if there already exists a cached marker set for this geoHash (in this case, from the device location)
    if (localEvents.embedded != null &&
        !getIt<CachedMarkers>().cachedMarkers.containsKey(geoHash)) {
      latlng = await addressToLatLng(localEvents);
    }

    setState(() {
      // geoHash should not be null since we initialized it earlier using fetchEventsFromDeviceLocation().
      assert(geoHash != null);

      if (getIt<CachedMarkers>().cachedMarkers.containsKey(geoHash)) {
        _markers = getIt<CachedMarkers>().cachedMarkers[geoHash]!.markers;
      } else if (localEvents.embedded != null) {
        _markers.clear();

        for (final event in localEvents.embedded!.events) {
          if (event.location?.lat != null && event.location?.lng != null) {
            final marker = Marker(
              markerId: MarkerId(event.name ?? 'No name'),
              position:
                  LatLng(event.location?.lat ?? 0, event.location?.lng ?? 0),
              infoWindow: InfoWindow(
                title: event.name,
                snippet: event.embedded?.venues?.fold(
                  '',
                  (p, e) =>
                      '$p ${e.address?.line1} ${e.address?.line2} ${e.address?.line3}'
                          .replaceAll('null', ''),
                ),
              ),
            );
            _markers[event.id] = marker;
          } else {
            // if we have no location object with lat/lng pairs, and no addresses either,
            // then we should have no marker for that event
            if (event.embedded?.venues?[0].address?.line1 == null) {
              continue;
            }

            final marker = Marker(
              markerId: MarkerId(event.name ?? 'No name'),
              position: latlng[event.id] ?? LatLng(0, 0),
              infoWindow: InfoWindow(
                title: event.name,
                snippet: event.embedded?.venues?.fold(
                  '',
                  (p, e) =>
                      '$p ${e.address?.line1} ${e.address?.line2} ${e.address?.line3}'
                          .replaceAll('null', ''),
                ),
              ),
            );
            _markers[event.id] = marker;
          }
        }
      }
      // save this geohash's event markers
      getIt<CachedMarkers>().cachedMarkers[geoHash!] = Markers(_markers);
    });
  }

  Future<Map<String, LatLng>> addressToLatLng(
      events.Response localEvents) async {
    for (final event in localEvents.embedded!.events) {
      if (event.location?.lat == null && event.location?.lng == null) {
        // we don't want to call geocoder, give it nulls, and recieve bogus markers. We'd rather have no markers at all then
        if (event.embedded?.venues?[0].address?.line1 != null) {
          final location = await geo_coder.locationFromAddress(
            '''
              ${event.embedded!.venues![0].address!.line1}, 
              ${event.embedded!.venues![0].city?.name}, 
              ${event.embedded!.venues![0].state?.stateCode} 
              ${event.embedded!.venues![0].postalCode} 
              ${event.embedded!.venues![0].country?.countryCode}
              '''
                .replaceAll('\n', '')
                .replaceAll('null', ''),
          );
          latlng[event.id] = LatLng(
            location.first.latitude,
            location.first.longitude,
          );
        }
      }
    }

    return latlng;
  }

  // should only be triggered when there is an HTTP GET request error
  Future<void> _showRequestError(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<events.Response>(
      future: localEventsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 2,
              ),
              markers: _markers.values.toSet(),
            ),
          );
        } else if (snapshot.hasError) {
          // ignore: discarded_futures
          _showRequestError('${snapshot.error}');
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
