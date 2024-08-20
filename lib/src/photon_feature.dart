import 'package:flutter_photon/src/lat_lng.dart';
import 'package:flutter_photon/src/photon_bounding_box.dart';

/// Contains all data returned from the Photon API
class PhotonFeature {
  /// Coordinates of a place or the center coordinate for a rectangle
  final LatLng coordinates;

  /// OpenStreetMap ID
  final int osmId;
  final String osmKey;

  /// Possible values are 'R' (relation), 'W' (way), 'N' (node). This may be changed in the future.
  final String osmType;
  final String osmValue;
  final String type;

  /// The bounding box of a relation (only available if [osmType] is 'R')
  late final PhotonBoundingBox? extentBoundingBox;

  final String? country;

  /// ISO 3166-1 alpha-2 code of the [country]
  final String? countryIsoCode;

  final String? name;

  final String? street;
  final String? houseNumber;
  final String? postcode;
  final String? district;
  final String? city;
  final String? county;
  final String? state;

  PhotonFeature(
      {required this.coordinates,
      required this.osmId,
      required this.osmKey,
      required this.osmType,
      required this.osmValue,
      required this.type,
      this.country,
      this.countryIsoCode,
      this.name,
      this.street,
      this.houseNumber,
      this.postcode,
      this.district,
      this.city,
      this.county,
      this.state,
      List<LatLng>? extent}) {
    if (extent != null && extent.isNotEmpty) {
      final northWest = extent[0];
      final southEast = extent[1];
      extentBoundingBox = PhotonBoundingBox(northWest.longitude,
          southEast.latitude, southEast.longitude, northWest.latitude);
    }
  }

  factory PhotonFeature.fromJson(Map<String, dynamic> json) {
    final coordinates = json['geometry']['coordinates'] as List<dynamic>;
    final center = LatLng(coordinates[1], coordinates[0]);

    final properties = json['properties'];

    final osmType = properties['osm_type'];

    List<LatLng>? extent;
    if (osmType == 'R') {
      final jsonExtent = properties['extent'] as List<dynamic>;
      extent = [
        LatLng(jsonExtent[1], jsonExtent[0]),
        LatLng(jsonExtent[3], jsonExtent[2])
      ];
    }

    return PhotonFeature(
        coordinates: center,
        osmId: properties['osm_id'],
        osmKey: properties['osm_key'],
        osmType: osmType,
        osmValue: properties['osm_value'],
        type: properties['type'],
        extent: extent,
        country: properties['country'],
        countryIsoCode: properties['countrycode'],
        name: properties['name'],
        street: properties['street'],
        houseNumber: properties['housenumber'],
        postcode: properties['postcode'],
        district: properties['district'],
        city: properties['city'],
        county: properties['county'],
        state: properties['state']);
  }
}
