import 'package:flutter/widgets.dart';

///
extension DebuggableWidget on Widget {
  ///
  Widget border({Color? color}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color:
              color ??
              const Color.from(
                alpha: 1,
                red: 1,
                green: 0,
                blue: 0,
              ),
        ),
      ),
      child: this,
    );
  }

  ///
  Widget withBorder({Color? color}) => border(color: color);
}
