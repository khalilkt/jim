import 'dart:ui';

import 'constants.dart';

class SS {
  static late double w;
  static late double h;
  static late double ww;
  static late double hh;
  static bool inited = false;

  static void init(Size size) {
    ww = size.width;
    hh = size.height;
    w = ww / 10;
    h = hh / 10;
    inited = true;
    log('SS INITED  : $size');
  }
}
