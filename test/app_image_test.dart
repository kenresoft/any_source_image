import 'dart:convert';
import 'dart:io';

import 'package:any_source_image/any_source_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// A 1x1 transparent PNG.
final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

Widget host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

void main() {
  const marker = Key('error-marker');

  group('source detection', () {
    testWidgets('null, empty, blank and unsupported types show the error widget', (tester) async {
      for (final source in <dynamic>[
        null,
        '',
        '   ',
        42,
        <int>[1],
      ]) {
        await tester.pumpWidget(host(AppImage(source, errorWidget: const SizedBox(key: marker))));
        expect(find.byKey(marker), findsOneWidget, reason: '$source');
        expect(find.byType(Image), findsNothing);
      }
    });

    testWidgets('without an error widget the default broken-image icon shows', (tester) async {
      await tester.pumpWidget(host(const AppImage(null)));
      expect(find.byIcon(Icons.broken_image), findsOneWidget);
    });

    testWidgets('a plain path is loaded as an asset', (tester) async {
      await tester.pumpWidget(host(const AppImage('assets/missing.png', width: 40, height: 40)));
      final image = tester.widget<Image>(find.byType(Image));
      expect(
        image.image,
        isA<ResizeImage>().having((r) => r.imageProvider, 'provider', isA<AssetImage>()),
      );
    });

    testWidgets('http and https URLs use the cached network image', (tester) async {
      for (final url in [
        'https://example.com/a.png',
        'http://example.com/a.png',
        ' https://example.com/a.png ',
      ]) {
        await tester.pumpWidget(host(AppImage(url, width: 30, height: 30)));
        expect(find.byType(CachedNetworkImage), findsOneWidget, reason: url);
        // the cache plugins are not available in unit tests; that failure is not under test
        tester.takeException();
      }
    });

    testWidgets('a missing asset falls back to the error widget', (tester) async {
      await tester.pumpWidget(
        host(const AppImage('assets/missing.png', errorWidget: SizedBox(key: marker))),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(marker), findsOneWidget);
    });

    testWidgets('a File is loaded from disk', (tester) async {
      final dir = Directory.systemTemp.createTempSync('any_source_image_');
      addTearDown(() => dir.deleteSync(recursive: true));
      final file = File('${dir.path}/p.png')..writeAsBytesSync(_png);
      await tester.pumpWidget(host(AppImage(file, width: 20, height: 20)));
      final image = tester.widget<Image>(find.byType(Image));
      expect(
        image.image,
        isA<ResizeImage>().having((r) => r.imageProvider, 'provider', isA<FileImage>()),
      );
    });

    testWidgets('a missing File falls back to the error widget', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          host(AppImage(File('/no/such/file.png'), errorWidget: const SizedBox(key: marker))),
        );
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump();
      expect(find.byKey(marker), findsOneWidget);
    });
  });

  group('layout', () {
    testWidgets('a border radius clips and a background colour wraps', (tester) async {
      await tester.pumpWidget(
        host(
          AppImage(
            null,
            width: 50,
            height: 50,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: Colors.red,
          ),
        ),
      );
      expect(find.byType(ClipRRect), findsOneWidget);
      final box = tester.widget<Container>(find.byType(Container).first);
      expect(box.color, Colors.red);
    });
  });

  group('AppCircleImage', () {
    testWidgets('is a circle of the given radius, clipped by default', (tester) async {
      await tester.pumpWidget(host(const AppCircleImage(null, radius: 24)));
      expect(tester.getSize(find.byType(CircleAvatar)), const Size(48, 48));
      expect(find.byType(ClipOval), findsOneWidget);
    });

    testWidgets('clip: false leaves the image unclipped', (tester) async {
      await tester.pumpWidget(host(const AppCircleImage(null, clip: false)));
      expect(find.byType(ClipOval), findsNothing);
    });
  });

  group('String helpers', () {
    testWidgets('img() asks for the asset and falls back to AppImage', (tester) async {
      await tester.pumpWidget(host('assets/missing.png'.img(width: 30, height: 30)));
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<ExactAssetImage>());
      expect(image.width, 30);
      await tester.pumpAndSettle();
      expect(find.byType(AppImage), findsOneWidget, reason: 'asset failed, so the fallback widget');
    });

    testWidgets('circleImage() builds an AppCircleImage of the radius', (tester) async {
      await tester.pumpWidget(host('assets/a.png'.circleImage(radius: 10)));
      final c = tester.widget<AppCircleImage>(find.byType(AppCircleImage));
      expect(c.radius, 10);
    });
  });

  group('ImageBackground', () {
    testWidgets('shows the child over the background', (tester) async {
      await tester.pumpWidget(
        host(const ImageBackground(imageSource: null, width: 100, height: 60, child: Text('over'))),
      );
      expect(find.text('over'), findsOneWidget);
    });

    testWidgets('circle constructor is twice the radius wide and high', (tester) async {
      await tester.pumpWidget(
        host(const ImageBackground.circle(imageSource: null, radius: 20, child: Text('c'))),
      );
      expect(tester.getSize(find.byType(SizedBox).first), const Size(40, 40));
      expect(find.text('c'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
