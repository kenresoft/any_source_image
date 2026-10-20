# any_source_image

One widget that shows an image from any source. Give it a network URL, an asset
path or a `File` and it picks the right way to load it. Network images are
cached on the device. While one loads you see a placeholder, and if it cannot be
loaded you see a fallback image or an error widget instead of a red screen.

This code was part of `extensionresoft` 1.x. It is its own package so that apps
that do not need network images do not pull in `cached_network_image` and the
database plugin it uses for its cache.

## Use it

```dart
import 'package:any_source_image/any_source_image.dart';

// a network URL, an asset path or a File: the widget works out which
AppImage('https://example.com/photo.jpg', width: 200, height: 120);
AppImage('assets/logo.png', fit: BoxFit.contain);
AppImage(File(path), borderRadius: BorderRadius.circular(12));

// what to show while loading and when it fails
AppImage(
  url,
  placeholder: const CircularProgressIndicator(),
  fallbackImage: 'assets/placeholder.png',
  errorWidget: const Icon(Icons.broken_image),
);

// a circular avatar, same sources
AppCircleImage(user.photoUrl, radius: 28);

// a background with a child on top
ImageBackground(imageSource: 'assets/bg.jpg', child: const Text('Hello'));
```

How the source is chosen: a `File` is a file; a string that starts with
`http://` or `https://` (or parses as a URI with a scheme and host) is a network
image; any other non-empty string is an asset path; `null`, an empty string or
any other type shows the fallback.

### String helpers

```dart
'assets/logo.png'.img(width: 100, height: 100);
'https://example.com/a.png'.circleImage(radius: 24);
```

`img()` loads the string as an asset first and falls back to `AppImage` if that
fails, so it also works for URLs.

## Notes

- `ImageBackground.circle` is experimental: the original code marks its edge cases as still being tested.
- On the web, network images use `Image.network` (no cache) and `File` is not
  supported, so a `File` shows the fallback.
- Decoding width is limited to the widget width times the device pixel ratio to
  save memory.

## License

BSD-3-Clause, see [LICENSE](LICENSE).
