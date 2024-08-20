import 'package:flutter_photon/src/models/lat_lng.dart';

/// Defines a bounding box object based on two coordinates.
class PhotonBoundingBox {
  /// The sourh-west corner of the bounding box
  LatLng southWest;

  /// The north-east corner of the bounding box
  LatLng northEast;

  PhotonBoundingBox(num lonSW, num latSW, num lonNE, num latNE)
      : northEast = LatLng(latNE, lonNE),
        southWest = LatLng(latSW, lonSW);

  /// Builds a string that can be used for and is understood by the Photon API
  String buildRequestString() {
    return '${southWest.longitude},${southWest.latitude},${northEast.longitude},${northEast.latitude}';
  }
}
