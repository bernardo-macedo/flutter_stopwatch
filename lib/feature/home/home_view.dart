import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stopwatch/config/l10n.dart';
import 'package:flutter_stopwatch/util/time_picker.dart';
import 'package:flutter_stopwatch/util/view_helpers.dart';

abstract class HomeView {
  SafeArea buildHomeBody(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          buildTopRightBgImage(),
          buildBottomRightBgImage(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildStopwatchIcon(),
                ViewHelpers.verticalSpacing(),
                buildTitle(context),
                buildSwitchesRow(context),
                Spacer(),
                buildTimeWidget(),
                ViewHelpers.verticalSpacing(space: 30),
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15, bottom: 60),
                    child: buildButtonsRow(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSwitchesRow(BuildContext context);

  Widget buildBottomRightBgImage() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Opacity(
        opacity: 0.3,
        child: Image.asset(
          'images/img_clock.png',
          scale: 2.3,
        ),
      ),
    );
  }

  Widget buildTopRightBgImage() {
    return Align(
      alignment: Alignment.topRight,
      child: Image.asset(
        'images/img_translucent_stopwatch.png',
        scale: 2.3,
      ),
    );
  }

  Widget buildStopwatchIcon() {
    return Image.asset(
      'images/ic_stopwatch.png',
      width: 60,
      height: 60,
    );
  }

  Widget buildTitle(BuildContext context) {
    return Text(
      L10n.getString(context, 'home_title'),
      style: TextStyle(color: Colors.white, fontFamily: 'Medium', fontSize: 50),
    );
  }

  Widget buildTimeWidget();

  Widget buildTimePicker(Function onTimeChange) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10)),
      child: TimePickerSpinner(
        normalTextStyle: TextStyle(
          fontFamily: 'Regular',
          fontSize: 40,
          color: Colors.grey.withOpacity(0.5),
        ),
        highlightedTextStyle: TextStyle(
          fontFamily: 'Regular',
          fontSize: 60,
          color: Colors.white,
        ),
        itemHeight: 80,
        itemWidth: 80,
        onTimeChange: onTimeChange,
      ),
    );
  }

  Widget buildTextTime(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Regular',
        fontSize: 60,
        color: Colors.white,
      ),
    );
  }

  Widget buildButtonsRow(BuildContext context);

  Widget buildButton(String label, Function action, {Color color}) {
    return Container(
      width: 120,
      child: RaisedButton(
        padding: EdgeInsets.only(top: 8, bottom: 12),
        elevation: 10,
        color: color ?? Colors.grey[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () {
          action();
        },
      ),
    );
  }
}
