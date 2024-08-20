import 'package:flutter_photon/src/models/lat_lng.dart';

class PhotonBoundingBox {
  LatLng southWest;
  LatLng northEast;

  PhotonBoundingBox(num lonSW, num latSW, num lonNE, num latNE)
      : northEast = LatLng(latNE, lonNE),
        southWest = LatLng(latSW, lonSW);

  String buildRequestString() {
    return '${southWest.longitude},${southWest.latitude},${northEast.longitude},${northEast.latitude}';
  }
}
