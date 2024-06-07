import 'package:flutter/material.dart';

SliverGridDelegateWithFixedCrossAxisCount movieSliverGridDelegate(
  BuildContext context,
) {
  final screen = MediaQuery.of(context);
  final widthScreen = screen.size.width;
  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: widthScreen > 600
        ? 4
        : widthScreen > 500
            ? 3
            : 2,
    crossAxisSpacing: widthScreen > 600 ? 16 : 16,
    mainAxisSpacing: widthScreen > 600 ? 24 : 20,
    childAspectRatio: posterAspectRatio,
  );
}

const double posterAspectRatio = 0.65;
const double heightAppbar = 80;
