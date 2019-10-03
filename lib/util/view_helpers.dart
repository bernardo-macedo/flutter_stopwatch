import 'package:flutter/widgets.dart';

class ViewHelpers {
  static SizedBox verticalSpacing({double height = 16}) {
    return SizedBox(
      height: height,
    );
  }

  static SizedBox horizontalSpacing({double width = 8}) {
    return SizedBox(
      width: width,
    );
  }
}
