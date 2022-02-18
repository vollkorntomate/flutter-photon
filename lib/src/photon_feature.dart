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

  /// A list containing two corners (north-west, south-east) if [osmType] is 'R'
  @Deprecated('Use extentBoundingBox instead')
  late final List<LatLng>? extent;

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
      this.coordinates,
      this.osmId,
      this.osmKey,
      this.osmType,
      this.osmValue,
      this.type,
      this.extent,
      this.country,
      this.countryIsoCode,
      this.name,
      this.street,
      this.houseNumber,
      this.postcode,
      this.district,
      this.city,
      this.county,
      this.state) {
    final extent = this.extent;
    if (extent != null && extent.isNotEmpty) {
      final northWest = extent[0];
      final southEast = extent[1];
      extentBoundingBox = PhotonBoundingBox(northWest.longitude,
          southEast.latitude, southEast.longitude, northWest.latitude);
    } else {
      extentBoundingBox = null;
    }
  }

  factory PhotonFeature.fromJson(Map<String, dynamic> json) {
    final coordinates = json['geometry']['coordinates'] as List<dynamic>;
    final center = LatLng(coordinates[1], coordinates[0]);

    final properties = json['properties'];

    final osmType = properties['osm_type'];

    var extent;
    if (osmType == 'R') {
      final jsonExtent = properties['extent'] as List<dynamic>;
      extent = [
        LatLng(jsonExtent[1], jsonExtent[0]),
        LatLng(jsonExtent[3], jsonExtent[2])
      ];
    }

    return PhotonFeature(
        center,
        properties['osm_id'],
        properties['osm_key'],
        osmType,
        properties['osm_value'],
        properties['type'],
        extent,
        properties['country'],
        properties['countrycode'],
        properties['name'],
        properties['street'],
        properties['housenumber'],
        properties['postcode'],
        properties['district'],
        properties['city'],
        properties['county'],
        properties['state']);
  }
}
