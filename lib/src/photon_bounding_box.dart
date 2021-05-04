import 'package:latlng/latlng.dart';

class PhotonBoundingBox {
  LatLng southWest;
  LatLng northEast;

  PhotonBoundingBox(double lonSW, double latSW, double lonNE, double latNE)
      : northEast = LatLng(latNE, lonNE),
        southWest = LatLng(latSW, lonSW);

  String buildRequestString() {
    return '${southWest.longitude},${southWest.latitude},${northEast.longitude},${northEast.latitude}';
  }
}
