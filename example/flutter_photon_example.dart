import 'package:flutter_photon/src/photon_api.dart';

void main() {
  final api = PhotonApi();
  final places = api.forwardSearch('munich');
  final reverse = api.reverseSearch(48.5, 11.5);
}
