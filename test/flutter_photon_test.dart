import 'package:flutter_photon/flutter_photon.dart';
import 'package:flutter_photon/src/models/photon_bounding_box.dart';
import 'package:flutter_photon/src/models/photon_layer.dart';
import 'package:test/test.dart';

void main() async {
  final api = PhotonApi();

  group('PhotonApi::forwardSearch', () {
    test(' returns elements for a common place', () async {
      final results = await api.forwardSearch('munich');
      expect(results, isNotEmpty);
    });

    test(' returns elements for oceans', () async {
      final results = await api.forwardSearch('Atlantic Ocean');
      expect(results, isNotEmpty);
    });

    test(' limits results if limit is given', () async {
      final results = await api.forwardSearch('munich',
          params: PhotonForwardParams(limit: 2));
      expect(results.length, allOf(greaterThan(0), lessThanOrEqualTo(2)));
    });

    test(' prioritizes places close to given location', () async {
      final results = await api.forwardSearch('munich',
          params: PhotonForwardParams(latitude: 48.6701, longitude: -98.8485));
      expect(results, isNotEmpty);
      expect(results.first.countryIsoCode, equalsIgnoringCase('US'));
    });

    test(' uses the provided language code', () async {
      final results = await api.forwardSearch('münchen',
          params: PhotonForwardParams(langCode: 'FR'));
      expect(results, isNotEmpty);
      expect(results.first.country, equals('Allemagne'));
    });

    test(' uses the provided bounding box', () async {
      final bboxBavaria = PhotonBoundingBox(10.0, 46.0, 12.0, 48.0);
      final bboxThuringia = PhotonBoundingBox(11.0, 50.0, 12.0, 51.0);

      final resultBavaria = await api.forwardSearch('münchen',
          params:
              PhotonForwardParams(langCode: 'DE', boundingBox: bboxBavaria));
      final resultThuringia = await api.forwardSearch('münchen',
          params:
              PhotonForwardParams(langCode: 'DE', boundingBox: bboxThuringia));

      expect(resultBavaria, isNotEmpty);
      expect(resultThuringia, isNotEmpty);
      expect(resultBavaria.first.state, equalsIgnoringCase('Bayern'));
      expect(resultThuringia.first.state, equalsIgnoringCase('Thüringen'));
    });

    test(' uses layer', () async {
      final resultWithLayer = await api.forwardSearch('bayern',
          params: PhotonForwardParams(layer: PhotonLayer.state));
      final resultWithoutLayer = await api.forwardSearch('bayern');

      expect(resultWithLayer.length, equals(1));
      expect(resultWithLayer.first.type, equals('state'));
      expect(resultWithoutLayer.length, isNot(resultWithLayer.length));
    });
  });

  group('PhotonApi::reverseSearch', () {
    test(' gives at least one result for a place', () async {
      final results = await api.reverseSearch(48.14368, 11.58775);
      expect(results, isNotEmpty);
    });

    test(' gives no result for a place without data', () async {
      // there is nothing at coordinates 1.0, 1.0
      final results = await api.reverseSearch(1.0, 1.0);
      expect(results, isEmpty);
    });

    test(' gives a result for a place without data and a radius', () async {
      final results = await api.reverseSearch(47.8912, 12.4639,
          params: PhotonReverseParams(radius: 8));
      expect(results, isNotEmpty);
    });

    test(' uses the provided language code', () async {
      final results = await api.reverseSearch(48.14368, 11.58775,
          params: PhotonReverseParams(langCode: 'FR'));
      expect(results, isNotEmpty);
      expect(results.first.country, equals('Allemagne'));
    });

    test(' uses layer', () async {
      final resultWithLayer = await api.reverseSearch(48.1379, 11.5734,
          params: PhotonReverseParams(layer: PhotonLayer.city));
      final resultWithoutLayer = await api.reverseSearch(48.1379, 11.5734);

      expect(resultWithLayer.length, equals(1));
      expect(resultWithLayer.first.type, equals('city'));
      expect(resultWithLayer.first.type, isNot(resultWithoutLayer.first.type));
    });
  });
}
