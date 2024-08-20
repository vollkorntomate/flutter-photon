import 'dart:convert';

import 'package:flutter_photon/flutter_photon.dart';
import 'package:http/http.dart' as http;

/// Wrapper of the Komoot Photon API for Flutter, providing forward and reverse geocoding.
class PhotonApi {
  final Uri _baseUri;
  final String _forwardEndpoint = '/api';
  final String _reverseEndpoint = '/reverse';

  /// Creates an instance of the Photon API Client.
  /// The [baseUrl] parameter can be set to a custom URL if needed.
  PhotonApi({String baseUrl = 'https://photon.komoot.io'})
      : _baseUri = Uri.parse(_trimTrailingSlash(baseUrl));

  static String _trimTrailingSlash(String baseUrl) {
    return baseUrl.endsWith('/')
        ? baseUrl.replaceRange(baseUrl.length - 1, baseUrl.length, '')
        : baseUrl;
  }

  /// Does a forward search with the given [searchText].
  ///
  /// The search can be improved or further influenced by specifying a set of [params].
  ///
  /// If [secure] is set to false, requests will be performed via HTTP, otherweise HTTPS is used (default).
  ///
  /// Throws an exception if the API response has a status code different than 200.
  Future<List<PhotonFeature>> forwardSearch(String searchText,
      {bool secure = true,
      PhotonForwardParams params = const PhotonForwardParams()}) async {
    var queryParams = params.buildQueryParameters();
    queryParams['q'] = searchText;

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
  ///
  /// The search can be improved or further influenced by specifying a set of [params].
  ///
  /// If [secure] is set to false, requests will be performed via HTTP, otherweise HTTPS is used (default).
  ///
  /// Throws an exception if the API response has a status code different than 200.
  Future<List<PhotonFeature>> reverseSearch(double latitude, double longitude,
      {bool secure = true,
      PhotonReverseParams params = const PhotonReverseParams()}) async {
    var queryParams = params.buildQueryParameters();
    queryParams['lon'] = '$longitude';
    queryParams['lat'] = '$latitude';

    final uri = secure
        ? Uri.https(
            _baseUri.authority, _baseUri.path + _reverseEndpoint, queryParams)
        : Uri.http(
            _baseUri.authority, _baseUri.path + _reverseEndpoint, queryParams);
    final res = await http.get(uri);

    return _handleResponse(res);
  }

  List<PhotonFeature> _handleResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw PhotonException(jsonDecode(response.body)['message'] ?? '');
    }

    final features = jsonDecode(response.body)['features'] as List<dynamic>;

    return features.map((f) => PhotonFeature.fromJson(f)).toList();
  }
}
