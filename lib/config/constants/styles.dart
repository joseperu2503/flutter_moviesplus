import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/breakpoints.dart';

SliverGridDelegateWithFixedCrossAxisCount movieSliverGridDelegate(
  double width,
) {
  final widthScreen = width;
  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: numMovieColumns(width),
    crossAxisSpacing: widthScreen > Breakpoints.md ? 16 : 16,
    mainAxisSpacing: widthScreen > Breakpoints.md ? 24 : 20,
    childAspectRatio: posterAspectRatio,
  );
}

int numMovieColumns(
  double width,
) {
  if (width < Breakpoints.sm) {
    return 2;
  }

  if (width < Breakpoints.md) {
    return 3;
  }

  if (width < Breakpoints.lg) {
    return 4;
  }

  if (width < Breakpoints.xl) {
    return 5;
  }

  return 6;
}

const double posterAspectRatio = 0.65;
const double heightAppbar = 80;
const double horizontalPaddingWeb = 16;
const double horizontalPaddingMobile = 16;
