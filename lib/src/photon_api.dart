import 'dart:convert';

import 'package:flutter_photon/src/photon_exception.dart';
import 'package:flutter_photon/src/photon_feature.dart';
import 'package:http/http.dart' as http;

class PhotonApi {
  final Uri _baseUri;
  final String _forwardEndpoint = '/api';
  final String _reverseEndpoint = '/reverse';

  /// Creates an instance of the Photon API Client.
  /// The [baseUrl] parameter can be set to a custom URL if needed.
  PhotonApi({String baseUrl = 'photon.komoot.io'})
      : _baseUri = Uri.parse(_trimTrailingSlash(baseUrl));

  static String _trimTrailingSlash(String baseUrl) {
    return baseUrl.endsWith('/')
        ? baseUrl.replaceRange(baseUrl.length - 1, baseUrl.length, '')
        : baseUrl;
  }

  /// Does a forward search with the given [searchText].
  /// Results can be prioritized around a certain [latitude] and [longitude].
  /// The [langCode] is an ISO-639-1 language code. Supported languages are EN, DE, FR, IT.
  /// When no [langCode] is given, the default language is the main language at the result's location.
  /// If [secure] is set to false, requests will be performed via HTTP, otherweise HTTPS is used (default).
  Future<List<PhotonFeature>> forwardSearch(String searchText,
      {int? limit,
      double? latitude,
      double? longitude,
      String? langCode,
      bool secure = true}) async {
    final queryParams = _buildQueryParams(
        init: {'q': searchText},
        limit: limit,
        latitude: latitude,
        longitude: longitude,
        langCode: langCode);

    final uri = secure
        ? Uri.https(
            _baseUri.authority, _baseUri.path + _forwardEndpoint, queryParams)
        : Uri.http(
            _baseUri.authority, _baseUri.path + _forwardEndpoint, queryParams);
    final res = await http.get(uri);

    return _handleResponse(res);
  }

  /// Does a reverse search at the given [latitude] and [longitude].
  /// Returns an empty list if there are no results near the given location.
  /// Increasing the [radius] can give a higher chance of getting usable results.
  /// The [langCode] is an ISO-639-1 language code. Supported languages are EN, DE, FR, IT.
  /// When no [langCode] is given, the default language is the main language at the result's location.
  /// If [secure] is set to false, requests will be performed via HTTP, otherweise HTTPS is used (default).
  Future<List<PhotonFeature>> reverseSearch(double latitude, double longitude,
      {int? limit, String? langCode, int? radius, bool secure = true}) async {
    final queryParams = _buildQueryParams(
        latitude: latitude,
        longitude: longitude,
        init: radius != null ? {'radius': '$radius'} : {},
        limit: limit,
        langCode: langCode);

    final uri = secure
        ? Uri.https(
            _baseUri.authority, _baseUri.path + _reverseEndpoint, queryParams)
        : Uri.http(
            _baseUri.authority, _baseUri.path + _reverseEndpoint, queryParams);
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
