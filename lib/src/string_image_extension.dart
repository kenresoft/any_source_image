// Copyright 2023 kenresoft. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'app_circle_image.dart';
import 'app_image.dart';

/// Extension on String to create Image widgets with customizable properties.
extension CustomImageExtension on String {
  /// Creates an Image widget from an asset with customizable properties.
  ///
  /// The `img()` function creates an Image widget from the asset path with customizable scale, width, height, color, fit, alignment, and repeat properties. <br /><br />
  ///
  /// @param scale The scale factor for the image. <br /><br />
  /// @param width The width of the image. <br /><br />
  /// @param height The height of the image. <br /><br />
  /// @param color The color to blend with the image. <br /><br />
  /// @param fit How the image should be inscribed into the space. <br /><br />
  /// @param alignment How the image should be aligned within its container. <br /><br />
  /// @param repeat How the image should be repeated. <br /><br />
  /// @return An Image widget with the specified properties. <br /><br />
  ///
  /// Example:
  /// ```dart
  /// final imageWidget = 'assets/image.png'.img(width: 100, height: 100, fit: BoxFit.cover);
  /// ```
  Image img({
    double scale = 1.0,
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
  }) {
    return Image(
      image: ExactAssetImage(this, scale: scale),
      width: width,
      height: height,
      color: color,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      errorBuilder: (_, _, _) =>
          AppImage(this, fit: fit, height: height, width: width, backgroundColor: color),
    );
  }

  /// Creates a circular image container with customizable properties.
  ///
  /// The `circleImage()` function creates a circular image container with customizable fit, alignment, repeat, scale, and opacity properties. <br /><br />
  ///
  /// @param fit How the image should be inscribed into the space. <br /><br />
  /// @param alignment How the image should be aligned within its container. <br /><br />
  /// @param repeat How the image should be repeated. <br /><br />
  /// @param scale The scale factor for the image. <br /><br />
  /// @param opacity The opacity of the image. <br /><br />
  /// @return A circular image container with the specified properties. <br /><br />
  ///
  /// Example:
  /// ```dart
  /// final circleImageContainer = 'assets/avatar.png'.circleImage(fit: BoxFit.cover, opacity: 0.8);
  /// ```
  Widget circleImage({BoxFit fit = BoxFit.contain, double radius = 30.0, Color? color}) {
    return AppCircleImage(this, fit: fit, radius: radius, backgroundColor: color);
  }
}
