import 'package:flutter/material.dart';

SliverGridDelegateWithFixedCrossAxisCount movieSliverGridDelegate(
  double width,
) {
  final widthScreen = width;
  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: widthScreen > 992
        ? 6
        : widthScreen > 768
            ? 5
            : widthScreen > 500
                ? 4
                : widthScreen > 330
                    ? 3
                    : 2,
    crossAxisSpacing: widthScreen > 600 ? 16 : 16,
    mainAxisSpacing: widthScreen > 600 ? 24 : 20,
    childAspectRatio: posterAspectRatio,
  );
}

const double posterAspectRatio = 0.65;
const double heightAppbar = 80;
const double horizontalPaddingWeb = 42;
const double horizontalPaddingMobile = 24;
