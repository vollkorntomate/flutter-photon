import 'package:latlng/latlng.dart';

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
  final List<LatLng>? extent;

  final String country;
  /// ISO 3166-1 alpha-2 code of the [country]
  final String countryIsoCode;

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
      this.state);

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
