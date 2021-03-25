# flutter_photon

[![version](https://img.shields.io/badge/version-0.1.1-green.svg)]()
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
[![flutter_photon](https://img.shields.io/badge/pub.dev-v0.1.1-blue.svg)](https://pub.dev/packages/flutter_photon)

Wrapper for Komoot's Photon API for Dart/Flutter.

It supports forward and reverse geocoding as well as search-as-you-type.

## Photon

Photon is a free and open-source API hosted by Komoot and powered by ElasticSearch. It returns data from the OpenStreetMap project,
which is licensed under the [ODbL License](https://opendatacommons.org/licenses/odbl/).

The API is available at [photon.komoot.io](https://photon.komoot.io))
and licensed under the [Apache 2.0 License](https://www.apache.org/licenses/LICENSE-2.0).

**Important:** Please be aware of the Terms and Use of Photon! It is free to use, so please be fair and avoid excessive requests!

## Usage

Forward geocoding:
```dart
import 'package:flutter_photon/flutter_photon.dart';

void main() async {
  final api = PhotonApi();
  final results = await api.forwardSearch('munich');
}
```

Reverse geocoding:
```dart
import 'package:flutter_photon/flutter_photon.dart';

void main() async {
  final api = PhotonApi();
  final results = await api.reverseSearch(48.123, 11.321);
}
```

## Features and Bugs

Feel free to open a new issue! I am always happy to improve this package.

## Contribution

Feel free to open pull requests and help improving this package!
