// To summarize how this works: I'm basically turning every object in the JSON response into a class, and describing that object's fields in that class.
// The classes are nested according to the structure of the JSON response.
// You can compare the classes here to the objects in the discovery API from ticketmaster for a comparison
// https://developer.ticketmaster.com/products-and-docs/apis/discovery-api/v2/#search-events-v2 <-- API docs

import 'dart:convert';

import 'package:cen_project/user_location.dart' as user_device;
import 'package:dart_geohash/dart_geohash.dart' as geo_hash;
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:location/location.dart';
import '../logger_settings.dart';

import 'env.dart';

part 'events.g.dart';

@JsonSerializable()
class LatLng {
  LatLng({
    this.lat,
    this.lng,
  });

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngToJson(this);

  final double? lat;
  final double? lng;
}

@JsonSerializable()
class Image {
  Image(this.url, this.width, this.height, this.fallback, this.attribution);

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
  Map<String, dynamic> toJson() => _$ImageToJson(this);

  final String? url;
  final int? width;
  final int? height;
  final bool? fallback;
  final String? attribution;
}

// begin [Event] subclasses

@JsonSerializable()
class Start {
  Start({this.dateTime});

  factory Start.fromJson(Map<String, dynamic> json) => _$StartFromJson(json);
  Map<String, dynamic> toJson() => _$StartToJson(this);

  final String? dateTime;
}

@JsonSerializable()
class End {
  End({this.dateTime});

  factory End.fromJson(Map<String, dynamic> json) => _$EndFromJson(json);
  Map<String, dynamic> toJson() => _$EndToJson(this);

  final String? dateTime;
}

@JsonSerializable()
class Dates {
  Dates({this.start, this.end});

  factory Dates.fromJson(Map<String, dynamic> json) => _$DatesFromJson(json);
  Map<String, dynamic> toJson() => _$DatesToJson(this);

  final Start? start;
  final End? end;
}

@JsonSerializable()
class Accessibility {
  Accessibility({this.info});

  factory Accessibility.fromJson(Map<String, dynamic> json) =>
      _$AccessibilityFromJson(json);
  Map<String, dynamic> toJson() => _$AccessibilityToJson(this);

  final String? info;
}

// begin [Classification] subclasses

@JsonSerializable()
class Segment {
  Segment({
    this.name,
  });

  factory Segment.fromJson(Map<String, dynamic> json) =>
      _$SegmentFromJson(json);
  Map<String, dynamic> toJson() => _$SegmentToJson(this);

  final String? name;
}

// end [Classification] subclasses

@JsonSerializable()
class Classification {
  Classification({
    this.primary,
    this.segment,
  });

  factory Classification.fromJson(Map<String, dynamic> json) =>
      _$ClassificationFromJson(json);
  Map<String, dynamic> toJson() => _$ClassificationToJson(this);

  final Segment? segment;
  final bool? primary;
}

@JsonSerializable()
class Address {
  Address({required this.line1, this.line2, this.line3});

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);

  final String line1;
  final String? line2;
  final String? line3;
}

@JsonSerializable()
class City {
  City({this.name});

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
  Map<String, dynamic> toJson() => _$CityToJson(this);

  final String? name;
}

@JsonSerializable()
class State {
  State({this.stateCode});

  factory State.fromJson(Map<String, dynamic> json) => _$StateFromJson(json);
  Map<String, dynamic> toJson() => _$StateToJson(this);

  final String? stateCode;
}

@JsonSerializable()
class Country {
  Country({this.countryCode});

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);
  Map<String, dynamic> toJson() => _$CountryToJson(this);

  final String? countryCode;
}

@JsonSerializable()
class Venue {
  Venue({
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.url,
    this.images,
    required this.location,
  });

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
  Map<String, dynamic> toJson() => _$VenueToJson(this);

  final City? city;
  final State? state;
  final Country? country;
  final Address? address;
  final LatLng location;
  final List<Image>? images;
  final String? postalCode;
  final String? url;
}

@JsonSerializable()
class EventEmbedded {
  EventEmbedded({this.venues});

  factory EventEmbedded.fromJson(Map<String, dynamic> json) =>
      _$EventEmbeddedFromJson(json);
  Map<String, dynamic> toJson() => _$EventEmbeddedToJson(this);

  final List<Venue>? venues;
}

// end [Event] subclasses

@JsonSerializable()
class Event {
  Event({
    this.accessibility,
    this.classifications,
    this.dates,
    this.description,
    this.embedded,
    this.info,
    this.images,
    this.location,
    this.name,
    this.pleaseNote,
    this.url,
    required this.id,
    required this.distance,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);

  @JsonKey(name: '_embedded')
  final EventEmbedded? embedded;
  final LatLng? location;
  final Dates? dates;
  final Accessibility? accessibility;
  final List<Classification>? classifications;
  final List<Image>? images;
  final String? name;
  final String id;
  final String? url;
  final String? description;
  final String? info;
  final String? pleaseNote;
  final double distance;
}

@JsonSerializable()
class Events {
  Events({required this.events});

  factory Events.fromJson(Map<String, dynamic> json) => _$EventsFromJson(json);
  Map<String, dynamic> toJson() => _$EventsToJson(this);

  final List<Event> events;
}

@JsonSerializable()
class Response {
  Response({this.embedded});

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseToJson(this);

  @JsonKey(name: '_embedded')
  Events? embedded;
}

class CachedEvents {
  CachedEvents();

  // Maps the Response object to the geoHash which its API call used.
  // This way, if there already exists a Response for a location, we can simply fetch the cached value.
  final Map<String, Response> _cachedEvents = {};
  String?
      geoHash; // stores the current geoHash to ensure cache freshness (i.e. we're not returning stuff from an old location)

  Future<Response> fetchEvents(
    String geoHash, {
    int radius = 1,
    String unit = 'miles',
    String sort = 'distance,asc',
    int size = 20,
    int? page,
  }) async {
    this.geoHash = geoHash;

    if (_cachedEvents.containsKey(geoHash)) {
      return _cachedEvents[geoHash]!;
    }
    if (geoHash.length > 9) {
      throw Exception('geoHash.length must not be greater than 9');
    }

    final apiKey = Env.apiKey;
    final request = '''https://app.ticketmaster.com/discovery/v2/events.json?
  geoPoint=$geoHash
  &size=$size
  ${page != null ? '&page=$page' : ''}
  &sort=$sort
  &radius=$radius
  &unit=$unit
  &apikey=$apiKey
  '''
        .replaceAll('\n', '')
        .replaceAll(' ', ''); // multiline strings leave some undesirables

    int? error;
    try {
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        // cache our Response
        _cachedEvents[geoHash] = Response.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
        return _cachedEvents[geoHash]!;
      } else {
        logger.e('HTTP GET failed!\n Status Code: ${response.statusCode}');
        error = response.statusCode;
      }
    } catch (e, s) {
      logger.t('getEvents() error, stacktrace: ', error: e, stackTrace: s);
    }

    // should only be reached when there is an HTTP GET request with a non-200 status code
    throw Exception('Failed to load events. HTTP GET status code: $error');
  }

  Future<Response> fetchEventsFromDeviceLocation({
    int radius = 100,
    String unit = 'miles',
    String sort = 'distance,asc',
    int size = 200,
    int? page,
  }) async {
    final LocationData locationData = await user_device.location;
    late final String geoHash;
    if (locationData.longitude != null && locationData.latitude != null) {
      final hasher = geo_hash.GeoHasher();
      geoHash = hasher.encode(
          locationData.longitude as double, locationData.latitude as double,
          precision: 8);
    } else {
      throw Exception("Latitude or Longitude are null");
    }

    return fetchEvents(
      geoHash,
      radius: radius,
      unit: unit,
      sort: sort,
      size: size,
      page: page,
    );
  }
}
