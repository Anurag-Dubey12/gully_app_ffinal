import 'dart:ui';

import 'package:flutter/material.dart';
//dummy responsive file need to change the data and need to use it
class Window {
  static num FIGMA_DESIGN_WIDTH = 360;

  static num FIGMA_DESIGN_HEIGHT = 812;

  static num FIGMA_DESIGN_STATUS_BAR = 0;

  static num _width = 0;

  static num _height = 0;

  static num _safeHeight = 0;

  void adaptDeviceScreenSize({required FlutterView view}) {
    Size deviceScreenSize = view.physicalSize;

    double devicePixelRatio = view.devicePixelRatio;

    Size size = deviceScreenSize / devicePixelRatio;

    _width = size.width;

    _height = size.height;

    num statusBar = MediaQueryData.fromView(view).viewPadding.top;

    num bottomBar = MediaQueryData.fromView(view).viewPadding.bottom;

    num screenHeight = size.height - statusBar - bottomBar;

    _safeHeight = screenHeight;
  }

  static double get width => _width * 1.0;

  static double get height => _height * 1.0;

  static double get safeHeight => _safeHeight * 1.0;

  static double getHorizontalSize(double px) {
    return ((px * width) / FIGMA_DESIGN_WIDTH);
  }

  static double getRadiusSize(double px) {
    return ((px * width) / FIGMA_DESIGN_WIDTH);
  }

  static double getVerticalSize(double px) {
    return ((px * height) / (FIGMA_DESIGN_HEIGHT - FIGMA_DESIGN_STATUS_BAR));
  }

  static double getSize(double px) {
    var height = getVerticalSize(px);

    var width = getHorizontalSize(px);

    if (height < width) {
      return height;
    } else {
      return width;
    }
  }

  static double getFontSize(double px) {
    return getSize(px);
  }

  static EdgeInsets getPadding({
    double? all,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return getMarginOrPadding(
      all: all,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }

  static EdgeInsets getSymmetricPadding({
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: getHorizontalSize(horizontal),
      vertical: getVerticalSize(vertical),
    );
  }

  static EdgeInsets getMargin({
    double? all,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return getMarginOrPadding(
      all: all,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }

  static EdgeInsets getMarginOrPadding({
    double? all,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (all != null) {
      left = all;

      top = all;

      right = all;

      bottom = all;
    }

    return EdgeInsets.only(
      left: getHorizontalSize(
        left ?? 0,
      ),
      top: getVerticalSize(
        top ?? 0,
      ),
      right: getHorizontalSize(
        right ?? 0,
      ),
      bottom: getVerticalSize(
        bottom ?? 0,
      ),
    );
  }
}
