## 1.2.0 (2024-03-20)
- Update dependencies to newer versions
- Now requires Dart ^3.0.0

## 1.1.0 (2022-10-07)
- Add `layer` option
- Add `additionalQuery` parameter to support more query parameters and filtering by OSM tag and value

## 1.0.0 (2022-10-02)
- Equal to 0.4.0, I just switched to a more normalized version numbering

## 0.4.0 (2022-02-18)
- Fix exceptions when searching for oceans
- Fix exceptions with integer coordinates
- Remove Latlng as dependency
- BREAKING CHANGE: `latitude` and `longitude` are now `num` instead of `double`
- BREAKING CHANGE: `country` and `countryIsoCode` are now `String?` instead of `String`
- Thanks to [hallabrin](https://github.com/hallabrin) for reporting and fixing!

## 0.3.0 (2021-05-04)
- Add support for filtering results in a bounding box

## 0.2.1
- Bug fixes

## 0.2.0
- Add support for self-hosted instances
- Add support for non-secure requests (HTTP)

## 0.1.1
- Bug fixes

## 0.1.0

- Initial version, providing basic functionality
- May still contain a lot of bugs
