// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatLng _$LatLngFromJson(Map<String, dynamic> json) => LatLng(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LatLngToJson(LatLng instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

Image _$ImageFromJson(Map<String, dynamic> json) => Image(
      json['url'] as String?,
      (json['width'] as num?)?.toInt(),
      (json['height'] as num?)?.toInt(),
      json['fallback'] as bool?,
      json['attribution'] as String?,
    );

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'fallback': instance.fallback,
      'attribution': instance.attribution,
    };

Start _$StartFromJson(Map<String, dynamic> json) => Start(
      dateTime: json['dateTime'] as String?,
    );

Map<String, dynamic> _$StartToJson(Start instance) => <String, dynamic>{
      'dateTime': instance.dateTime,
    };

End _$EndFromJson(Map<String, dynamic> json) => End(
      dateTime: json['dateTime'] as String?,
    );

Map<String, dynamic> _$EndToJson(End instance) => <String, dynamic>{
      'dateTime': instance.dateTime,
    };

Dates _$DatesFromJson(Map<String, dynamic> json) => Dates(
      start: json['start'] == null
          ? null
          : Start.fromJson(json['start'] as Map<String, dynamic>),
      end: json['end'] == null
          ? null
          : End.fromJson(json['end'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DatesToJson(Dates instance) => <String, dynamic>{
      'start': instance.start,
      'end': instance.end,
    };

Accessibility _$AccessibilityFromJson(Map<String, dynamic> json) =>
    Accessibility(
      info: json['info'] as String?,
    );

Map<String, dynamic> _$AccessibilityToJson(Accessibility instance) =>
    <String, dynamic>{
      'info': instance.info,
    };

Segment _$SegmentFromJson(Map<String, dynamic> json) => Segment(
      name: json['name'] as String?,
    );

Map<String, dynamic> _$SegmentToJson(Segment instance) => <String, dynamic>{
      'name': instance.name,
    };

Classification _$ClassificationFromJson(Map<String, dynamic> json) =>
    Classification(
      primary: json['primary'] as bool?,
      segment: json['segment'] == null
          ? null
          : Segment.fromJson(json['segment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClassificationToJson(Classification instance) =>
    <String, dynamic>{
      'segment': instance.segment,
      'primary': instance.primary,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      line1: json['line1'] as String,
      line2: json['line2'] as String?,
      line3: json['line3'] as String?,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'line1': instance.line1,
      'line2': instance.line2,
      'line3': instance.line3,
    };

City _$CityFromJson(Map<String, dynamic> json) => City(
      name: json['name'] as String?,
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'name': instance.name,
    };

State _$StateFromJson(Map<String, dynamic> json) => State(
      stateCode: json['stateCode'] as String?,
    );

Map<String, dynamic> _$StateToJson(State instance) => <String, dynamic>{
      'stateCode': instance.stateCode,
    };

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      countryCode: json['countryCode'] as String?,
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'countryCode': instance.countryCode,
    };

Venue _$VenueFromJson(Map<String, dynamic> json) => Venue(
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      city: json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      state: json['state'] == null
          ? null
          : State.fromJson(json['state'] as Map<String, dynamic>),
      country: json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
      postalCode: json['postalCode'] as String?,
      url: json['url'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
          .toList(),
      location: LatLng.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VenueToJson(Venue instance) => <String, dynamic>{
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'address': instance.address,
      'location': instance.location,
      'images': instance.images,
      'postalCode': instance.postalCode,
      'url': instance.url,
    };

EventEmbedded _$EventEmbeddedFromJson(Map<String, dynamic> json) =>
    EventEmbedded(
      venues: (json['venues'] as List<dynamic>?)
          ?.map((e) => Venue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EventEmbeddedToJson(EventEmbedded instance) =>
    <String, dynamic>{
      'venues': instance.venues,
    };

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      accessibility: json['accessibility'] == null
          ? null
          : Accessibility.fromJson(
              json['accessibility'] as Map<String, dynamic>),
      classifications: (json['classifications'] as List<dynamic>?)
          ?.map((e) => Classification.fromJson(e as Map<String, dynamic>))
          .toList(),
      dates: json['dates'] == null
          ? null
          : Dates.fromJson(json['dates'] as Map<String, dynamic>),
      description: json['description'] as String?,
      embedded: json['_embedded'] == null
          ? null
          : EventEmbedded.fromJson(json['_embedded'] as Map<String, dynamic>),
      info: json['info'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
          .toList(),
      location: json['location'] == null
          ? null
          : LatLng.fromJson(json['location'] as Map<String, dynamic>),
      name: json['name'] as String?,
      pleaseNote: json['pleaseNote'] as String?,
      url: json['url'] as String?,
      id: json['id'] as String,
      distance: (json['distance'] as num).toDouble(),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      '_embedded': instance.embedded,
      'location': instance.location,
      'dates': instance.dates,
      'accessibility': instance.accessibility,
      'classifications': instance.classifications,
      'images': instance.images,
      'name': instance.name,
      'id': instance.id,
      'url': instance.url,
      'description': instance.description,
      'info': instance.info,
      'pleaseNote': instance.pleaseNote,
      'distance': instance.distance,
    };

Events _$EventsFromJson(Map<String, dynamic> json) => Events(
      events: (json['events'] as List<dynamic>)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EventsToJson(Events instance) => <String, dynamic>{
      'events': instance.events,
    };

Response _$ResponseFromJson(Map<String, dynamic> json) => Response(
      embedded: json['_embedded'] == null
          ? null
          : Events.fromJson(json['_embedded'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
      '_embedded': instance.embedded,
    };
