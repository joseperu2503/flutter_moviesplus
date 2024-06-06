import 'package:flutter/material.dart';

const double minHeightPhone = 500;

class Device {
  final BuildContext context;

  Device(this.context);

  bool get isPhone {
    final screen = MediaQuery.of(context);

    final aspectRatio = screen.size.aspectRatio;
    if (aspectRatio <= 1) {
      return screen.size.width < minHeightPhone;
    } else {
      return screen.size.height < minHeightPhone;
    }
  }
}
