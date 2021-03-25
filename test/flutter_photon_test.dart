import 'package:flutter_photon/flutter_photon.dart';
import 'package:test/test.dart';

void main() async {
  final api = PhotonApi();

  group('PhotonApi::forwardSearch', () {
    test(' returns elements for a common place', () async {
      final results = await api.forwardSearch('munich');
      expect(results, isNotEmpty);
    });

    test(' limits results if limit is given', () async {
      final results = await api.forwardSearch('munich', limit: 2);
      expect(results.length, allOf(greaterThan(0), lessThanOrEqualTo(2)));
    });

    test(' prioritizes places close to given location', () async {
      final results = await api.forwardSearch('munich', latitude: 48.6701, longitude: -98.8485);
      expect(results, isNotEmpty);
      expect(results.first.countryIsoCode, equalsIgnoringCase('US'));
    });

    test(' uses the provided language code', () async {
      final results = await api.forwardSearch('münchen', langCode: 'FR');
      expect(results, isNotEmpty);
      expect(results.first.country, equals('Allemagne'));
    });
  });

  group('PhotonApi::reverseSearch', () {
    test(' gives at least one result for a place', () async {
      final results = await api.reverseSearch(48.14368, 11.58775);
      expect(results, isNotEmpty);
    });
    
    test(' gives no result for a place without data', () async {
      final results = await api.reverseSearch(47.8912, 12.4639);
      expect(results, isEmpty);
    });

    test(' gives a result for a place without data and a radius', () async {
      final results = await api.reverseSearch(47.8912, 12.4639, radius: 8);
      expect(results, isNotEmpty);
    });

    test(' uses the provided language code', () async {
      final results = await api.reverseSearch(48.14368, 11.58775, langCode: 'FR');
      expect(results, isNotEmpty);
      expect(results.first.country, equals('Allemagne'));
    });
  });
}
