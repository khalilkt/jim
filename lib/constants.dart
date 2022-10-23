import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

const Color backColor = Color(0xff374050);
const Color primaryColor = Color(0xff424B5E);
const Color secondaryColor = Color(0xffEFD02D);

const double defPagePadding = 22;
const double defTilePadding = 20;
void log(String content, [String dep = '']) {
  if (kDebugMode) {
    print('---$dep--- $content');
  }
}
