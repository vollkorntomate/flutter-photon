import 'photon_bounding_box.dart';
import 'photon_layer.dart';

class PhotonParams {
  final int? limit;
  final double? latitude;
  final double? longitude;
  final String? langCode;
  final PhotonLayer? layer;
  final String? osmTag;
  final Map<String, String>? additionalQuery;

  const PhotonParams(
      {this.limit,
      this.latitude,
      this.longitude,
      this.langCode,
      this.layer,
      this.osmTag,
      this.additionalQuery});

  Map<String, String> buildQueryParameters() {
    Map<String, String> result = {};
    if (limit != null) {
      result['limit'] = '$limit';
    }
    if (latitude != null && longitude != null) {
      result['lat'] = '$latitude';
      result['lon'] = '$longitude';
    }
    final langCode = this.langCode;
    if (langCode != null) {
      result['lang'] = langCode.toLowerCase();
    }
    if (layer != null) {
      result['layer'] = layer.toString();
    }
    final osmTag = this.osmTag;
    if (osmTag != null) {
      result['osm_tag'] = osmTag;
    }
    final additionalQuery = this.additionalQuery;
    if (additionalQuery != null) {
      result.addAll(additionalQuery);
    }

    return result;
  }
}

class PhotonForwardParams extends PhotonParams {
  final PhotonBoundingBox? boundingBox;
  final int? zoom;
  final double? locationBiasScale;

  /// Improve your results based on additional parameters.
  /// - Prioritize locations within a certain [boundingBox] or around a certain [latitude] and [longitude]. Can be further influenced by [zoom] and [locationBiasScale], see [Photon's documentation](https://github.com/komoot/photon?tab=readme-ov-file#search-with-location-bias)
  /// - The [langCode] is an ISO-639-1 language code. Supported languages are EN, DE, FR. When no [langCode] is given, the default language is the main language at the result's location.
  /// - Use [layer] to filter by a certain layer, see [Photon documentation](https://github.com/komoot/photon#filter-results-by-layer) for this. [PhotonLayer] specifies constants that are ready to use.
  /// - Use [osmTag] to filter by certain OSM tags and values, see [Photon documentation](https://github.com/komoot/photon?tab=readme-ov-file#filter-results-by-tags-and-values) for this.
  /// - [limit] limits the number of search results
  /// - [additionalQuery] is for any additional URL query parameter, e.g., features that will be added in the future and aren't yet supported.
  const PhotonForwardParams(
      {this.boundingBox,
      this.zoom,
      this.locationBiasScale,
      super.limit,
      super.latitude,
      super.longitude,
      super.langCode,
      super.layer,
      super.osmTag,
      super.additionalQuery});

  @override
  Map<String, String> buildQueryParameters() {
    var result = super.buildQueryParameters();

    final boundingBox = this.boundingBox;
    if (boundingBox != null) {
      result['bbox'] = boundingBox.buildRequestString();
    }
    if (zoom != null) {
      result['zoom'] = '$zoom';
    }
    if (locationBiasScale != null) {
      result['location_bias_scale'] = '$locationBiasScale';
    }

    return result;
  }
}

class PhotonReverseParams extends PhotonParams {
  final String? queryFilter;
  final bool? distanceSort;
  final int? radius;

  /// Improve your results based on additional parameters.
  /// - [queryFilter] isn't documented in Photon
  /// - [distanceSort] isn't documented in Photon
  /// - [radius] describes a radius measured in kilometers around the search location. Must be between 0 and 5000.
  /// - The [langCode] is an ISO-639-1 language code. Supported languages are EN, DE, FR. When no [langCode] is given, the default language is the main language at the result's location.
  /// - Use [layer] to filter by a certain layer, see [Photon documentation](https://github.com/komoot/photon#filter-results-by-layer) for this. [PhotonLayer] specifies constants that are ready to use.
  /// - Use [osmTag] to filter by certain OSM tags and values, see [Photon documentation](https://github.com/komoot/photon?tab=readme-ov-file#filter-results-by-tags-and-values) for this.
  /// - [limit] limits the number of search results
  /// - [additionalQuery] is for any additional URL query parameter, e.g., features that will be added in the future and aren't yet supported.
  const PhotonReverseParams(
      {this.queryFilter,
      this.distanceSort,
      this.radius,
      super.limit,
      super.langCode,
      super.layer,
      super.osmTag,
      super.additionalQuery});

  @override
  Map<String, String> buildQueryParameters() {
    var result = super.buildQueryParameters();

    final queryFilter = this.queryFilter;
    if (queryFilter != null) {
      result['query_string_filter'] = queryFilter;
    }
    final distanceSort = this.distanceSort;
    if (distanceSort != null) {
      result['distance_sort'] = distanceSort ? '1' : '0';
    }
    if (radius != null) {
      result['radius'] = '$radius';
    }

    return result;
  }
}
