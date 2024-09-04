import 'package:flutter/cupertino.dart';


class SizeConfig {SizeConfig._();

  static double? screenHeight;
  static double? screenWidth;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;

  static void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
    } else {
      screenHeight = constraints.maxWidth;
      screenWidth = constraints.maxHeight;
    }
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;
  }

  static double setSp(num size) => size * blockSizeVertical!;
  static double setHeight(num size) => size * blockSizeVertical!;
  static double setWidth(num size) => size * blockSizeHorizontal!;
}

extension SizeExtensionInteger on num {
  double get t => SizeConfig.setSp(this);
  double get h => SizeConfig.setHeight(this);
  double get w => SizeConfig.setWidth(this);
}
