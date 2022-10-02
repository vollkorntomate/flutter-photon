class PhotonLayer {
  static final PhotonLayer house = PhotonLayer._('house');
  static final PhotonLayer street = PhotonLayer._('street');
  static final PhotonLayer locality = PhotonLayer._('locality');
  static final PhotonLayer district = PhotonLayer._('district');
  static final PhotonLayer city = PhotonLayer._('city');
  static final PhotonLayer county = PhotonLayer._('county');
  static final PhotonLayer state = PhotonLayer._('state');
  static final PhotonLayer country = PhotonLayer._('country');

  final String value;

  PhotonLayer._(this.value);

  @override
  String toString() {
    return value;
  }
}
