import 'package:flutter/widgets.dart';

class ViewHelpers {
  static SizedBox verticalSpacing({double space = 16}) {
    return SizedBox(
      height: space,
    );
  }

  static SizedBox horizontalSpacing({double space = 8}) {
    return SizedBox(
      width: space,
    );
  }
}
