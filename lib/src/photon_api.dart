import 'dart:convert';

import 'package:flutter_photon/src/photon_exception.dart';
import 'package:flutter_photon/src/photon_feature.dart';
import 'package:http/http.dart' as http;

class PhotonApi {
  final String _baseUrl = 'photon.komoot.io';
  final String _forwardEndpoint = '/api';
  final String _reverseEndpoint = '/reverse';

  /// Does a forward search with the given [searchText].
  /// Results can be prioritized around a certain [latitude] and [longitude].
  /// The [langCode] is an ISO-639-1 language code. Supported languages are EN, DE, FR, IT.
  /// When no [langCode] is given, the default language is the main language at the result's location.
  Future<List<PhotonFeature>> forwardSearch(String searchText,
      {int? limit,
      double? latitude,
      double? longitude,
      String? langCode}) async {
    final queryParams = _buildQueryParams(
        init: {'q': searchText},
        limit: limit,
        latitude: latitude,
        longitude: longitude,
        langCode: langCode);

    final uri = Uri.https(_baseUrl, _forwardEndpoint, queryParams);
    final res = await http.get(uri);

    return _handleResponse(res);
  }

  /// Does a reverse search at the given [latitude] and [longitude].
  /// Returns an empty list if there are no results near the given location.
  /// Increasing the [radius] can give a higher chance of getting usable results.
  /// The [langCode] is an ISO-639-1 language code. Supported languages are EN, DE, FR, IT.
  /// When no [langCode] is given, the default language is the main language at the result's location.
  Future<List<PhotonFeature>> reverseSearch(double latitude, double longitude,
      {int? limit, String? langCode, int? radius}) async {
    final queryParams = _buildQueryParams(
        latitude: latitude,
        longitude: longitude,
        init: radius != null ? {'radius': '$radius'} : {},
        limit: limit,
        langCode: langCode);

    final uri = Uri.https(_baseUrl, _reverseEndpoint, queryParams);
    final res = await http.get(uri);

    return _handleResponse(res);
  }

  Map<String, String> _buildQueryParams(
      {Map<String, String>? init,
      int? limit,
      double? latitude,
      double? longitude,
      String? langCode}) {
    init ??= {};
    if (limit != null) {
      init['limit'] = '$limit';
    }
    if (latitude != null && longitude != null) {
      init['lat'] = '$latitude';
      init['lon'] = '$longitude';
    }
    if (langCode != null) {
      init['lang'] = langCode.toLowerCase();
    }
    return init;
  }

  List<PhotonFeature> _handleResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw PhotonException(jsonDecode(response.body)['message'] ?? '');
    }

    final features = jsonDecode(response.body)['features'] as List<dynamic>;

    return features.map((f) => PhotonFeature.fromJson(f)).toList();
  }
}
