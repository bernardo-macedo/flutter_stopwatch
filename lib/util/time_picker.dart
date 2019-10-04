library time_picker_spinner;

import 'dart:math';

import 'package:flutter/material.dart';

/*
Class copied and adapted from:
https://github.com/icemanbsi/flutter_time_picker_spinner
 */

class ItemScrollPhysics extends ScrollPhysics {
  /// Creates physics for snapping to item.
  /// Based on PageScrollPhysics
  final double itemHeight;
  final double targetPixelsLimit;

  const ItemScrollPhysics({
    ScrollPhysics parent,
    this.itemHeight,
    this.targetPixelsLimit = 3.0,
  })  : assert(itemHeight != null && itemHeight > 0),
        super(parent: parent);

  @override
  ItemScrollPhysics applyTo(ScrollPhysics ancestor) {
    return ItemScrollPhysics(
        parent: buildParent(ancestor), itemHeight: itemHeight);
  }

  double _getItem(ScrollPosition position) {
    double maxScrollItem =
        (position.maxScrollExtent / itemHeight).floorToDouble();
    return min(max(0, position.pixels / itemHeight), maxScrollItem);
  }

  double _getPixels(ScrollPosition position, double item) {
    return item * itemHeight;
  }

  double _getTargetPixels(
      ScrollPosition position, Tolerance tolerance, double velocity) {
    double item = _getItem(position);
    if (velocity < -tolerance.velocity)
      item -= targetPixelsLimit;
    else if (velocity > tolerance.velocity) item += targetPixelsLimit;
    return _getPixels(position, item.roundToDouble());
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a item boundary.
//    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
//        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent))
//      return super.createBallisticSimulation(position, velocity);
    Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels)
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}

typedef SelectedIndexCallback = void Function(int);
typedef TimePickerCallback = void Function(DateTime);

class TimePickerSpinner extends StatefulWidget {
  final DateTime time;
  final TextStyle normalTextStyle;
  final TextStyle highlightedTextStyle;
  final double itemHeight;
  final double itemWidth;
  final double spacing;
  final bool isForce2Digits;
  final Function onTimeChange;

  TimePickerSpinner(
      {Key key,
      this.time,
      this.normalTextStyle,
      this.highlightedTextStyle,
      this.itemHeight,
      this.itemWidth,
      this.spacing,
      this.isForce2Digits = true,
      this.onTimeChange})
      : super(key: key);

  @override
  _TimePickerSpinnerState createState() => new _TimePickerSpinnerState();
}

class _TimePickerSpinnerState extends State<TimePickerSpinner> {
  ScrollController hourController = new ScrollController();
  ScrollController minuteController = new ScrollController();
  ScrollController secondController = new ScrollController();
  int currentSelectedHourIndex = -1;
  int currentSelectedMinuteIndex = -1;
  int currentSelectedSecondIndex = -1;
  int hourCount = 24;
  int minuteCount = 60;
  int secondsCount = 60;
  bool isHourScrolling = false;
  bool isMinuteScrolling = false;
  bool isSecondsScrolling = false;

  /// default settings
  double defaultItemHeight = 60;
  double defaultItemWidth = 50;
  double defaultSpacing = 20;

  /// getter

  TextStyle _getHighlightedTextStyle() {
    return widget.highlightedTextStyle ?? TextStyle(fontSize: 30);
  }

  TextStyle _getNormalTextStyle() {
    return widget.normalTextStyle ?? TextStyle(fontSize: 30);
  }

  double _getItemHeight() {
    return widget.itemHeight != null ? widget.itemHeight : defaultItemHeight;
  }

  double _getItemWidth() {
    return widget.itemWidth != null ? widget.itemWidth : defaultItemWidth;
  }

  double _getSpacing() {
    return widget.spacing != null ? widget.spacing : defaultSpacing;
  }

  bool isLoop(int value) {
    return value > 10;
  }

  int getMilliseconds() {
    int hour = currentSelectedHourIndex - hourCount;
    int minute =
        currentSelectedMinuteIndex - (isLoop(minuteCount) ? minuteCount : 1);
    int second =
        currentSelectedSecondIndex - (isLoop(secondsCount) ? secondsCount : 1);

    int hourInMilliseconds = hour * 60 * 60 * 1000;
    int minutesInMilliseconds = minute * 60 * 1000;
    int secondsInMilliseconds = second * 1000;

    return hourInMilliseconds + minutesInMilliseconds + secondsInMilliseconds;
  }

  @override
  void initState() {
    currentSelectedHourIndex = hourCount;
    hourController = new ScrollController(
        initialScrollOffset: (currentSelectedHourIndex - 1) * _getItemHeight());

    currentSelectedMinuteIndex = minuteCount;
    minuteController = new ScrollController(
        initialScrollOffset:
            (currentSelectedMinuteIndex - 1) * _getItemHeight());

    currentSelectedSecondIndex = secondsCount;
    secondController = new ScrollController(
        initialScrollOffset:
            (currentSelectedSecondIndex - 1) * _getItemHeight());

    super.initState();

    if (widget.onTimeChange != null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => widget.onTimeChange(getMilliseconds()));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> contents = [
      new SizedBox(
        width: _getItemWidth(),
        height: _getItemHeight() * 3,
        child: spinner(
          hourController,
          hourCount,
          currentSelectedHourIndex,
          isHourScrolling,
          (index) {
            currentSelectedHourIndex = index;
            isHourScrolling = true;
          },
          () => isHourScrolling = false,
        ),
      ),
      spacer(),
      new SizedBox(
        width: _getItemWidth(),
        height: _getItemHeight() * 3,
        child: spinner(
          minuteController,
          minuteCount,
          currentSelectedMinuteIndex,
          isMinuteScrolling,
          (index) {
            currentSelectedMinuteIndex = index;
            isMinuteScrolling = true;
          },
          () => isMinuteScrolling = false,
        ),
      ),
      spacer(),
      new SizedBox(
        width: _getItemWidth(),
        height: _getItemHeight() * 3,
        child: spinner(
          secondController,
          secondsCount,
          currentSelectedSecondIndex,
          isSecondsScrolling,
          (index) {
            currentSelectedSecondIndex = index;
            isSecondsScrolling = true;
          },
          () => isSecondsScrolling = false,
        ),
      ),
    ];

    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: contents,
    );
  }

  Widget spacer() {
    return new Container(
      width: _getSpacing(),
      height: _getItemHeight() * 3,
    );
  }

  Widget spinner(
      ScrollController controller,
      int max,
      int selectedIndex,
      bool isScrolling,
      SelectedIndexCallback onUpdateSelectedIndex,
      VoidCallback onScrollEnd) {
    /// wrapping the spinner with stack and add container above it when it's scrolling
    /// this thing is to prevent an error causing by some weird stuff like this
    /// flutter: Another exception was thrown: 'package:flutter/src/widgets/scrollable.dart': Failed assertion: line 469 pos 12: '_hold == null || _drag == null': is not true.
    /// maybe later we can find out why this error is happening

    Widget _spinner = NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is UserScrollNotification) {
          if (scrollNotification.direction.toString() ==
              "ScrollDirection.idle") {
            if (isLoop(max)) {
              int segment = (selectedIndex / max).floor();
              if (segment == 0) {
                onUpdateSelectedIndex(selectedIndex + max);
                controller.jumpTo(controller.offset + (max * _getItemHeight()));
              } else if (segment == 2) {
                onUpdateSelectedIndex(selectedIndex - max);
                controller.jumpTo(controller.offset - (max * _getItemHeight()));
              }
            }
            setState(() {
              onScrollEnd();
              if (widget.onTimeChange != null) {
                widget.onTimeChange(getMilliseconds());
              }
            });
          }
        } else if (scrollNotification is ScrollUpdateNotification) {
          setState(() {
            onUpdateSelectedIndex(
                (controller.offset / _getItemHeight()).round() + 1);
          });
        }
        return true;
      },
      child: new ListView.builder(
        itemBuilder: (context, index) {
          String text = '';
          if (isLoop(max)) {
            text = (index % max).toString();
          } else if (index != 0 && index != max + 1) {
            text = ((index - 1) % max).toString();
          }
          if (widget.isForce2Digits && text != '') {
            text = text.padLeft(2, '0');
          }
          return new Container(
            height: _getItemHeight(),
            alignment: Alignment.center,
            child: new Text(
              text,
              style: selectedIndex == index
                  ? _getHighlightedTextStyle()
                  : _getNormalTextStyle(),
            ),
          );
        },
        controller: controller,
        itemCount: isLoop(max) ? max * 3 : max + 2,
        physics: ItemScrollPhysics(itemHeight: _getItemHeight()),
      ),
    );

    return new Stack(
      children: <Widget>[
        Positioned.fill(child: _spinner),
        isScrolling
            ? Positioned.fill(
                child: new Container(
                color: Colors.black.withOpacity(0),
              ))
            : new Container()
      ],
    );
  }
}
