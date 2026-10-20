/// One image widget for a network URL, an asset path or a file.
///
/// Moved out of `extensionresoft` 1.x so that apps that do not need network
/// images do not have to depend on `cached_network_image` and its database
/// plugin.
library;

export 'src/app_circle_image.dart';
export 'src/app_image.dart';
export 'src/image_background.dart';
export 'src/string_image_extension.dart';
