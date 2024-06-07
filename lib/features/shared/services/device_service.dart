import 'package:flutter/material.dart';

const double minHeightPhone = 500;

class Device {
  final BuildContext context;

  Device(this.context);

  bool get isPhone {
    final screen = MediaQuery.of(context);

    return screen.size.width < minHeightPhone ||
        screen.size.height < minHeightPhone;
  }
}
