## 1.1.0

- Updated `cached_network_image` to `^4.0.5`. No API changes.
- The minimum is now Dart 3.12 and Flutter 3.44, which `cached_network_image` 4 needs. Apps on older Flutter keep resolving to 1.0.0, so nothing breaks; upgrade Flutter to get 1.1.0.

## 1.0.0

- First release as its own package. The code moved here from `extensionresoft` 1.5.x: `AppImage`, `AppCircleImage`, `ImageSourceType`, `ImageBackground`, and the `img()` and `circleImage()` helpers on `String` (`CustomImageExtension`).
- Imports changed from `package:extensionresoft/extensionresoft.dart` to `package:any_source_image/any_source_image.dart`.
- Migrating from `extensionresoft` 1.x: add `any_source_image` next to `extensionresoft: ^2.0.0` and change the import. No API changes. See the README.
