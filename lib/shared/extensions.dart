import 'dart:math';

import 'package:flutter/widgets.dart';

extension GlobalKeyExtension on GlobalKey {
  Rect get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null)?.getTranslation();
    if (translation != null && renderObject.paintBounds != null) {
      return renderObject.paintBounds
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}

extension ListHelpers on List {
  List randomizeList() {
    var random = new Random();
    for (var i = this.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);

      var temp = this[i];
      this[i] = this[n];
      this[n] = temp;
    }

    return this;
  }
}

extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == this.day &&
        now.month == this.month &&
        now.year == this.year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.day == this.day &&
        yesterday.month == this.month &&
        yesterday.year == this.year;
  }

  /// Returns the days since this date NOT assuming full 24 hour days but
  /// rather days of the weeek.
  /// For example, if this date is Thursday, 21.01.2021, 15:40 and it is
  /// Friday, 22.02.2021, 14:10, this function returns 1 as the number
  /// of days
  int daysAgo() {
    var compareDate = DateTime(this.year, this.month, this.day, 0, 0, 0);
    return DateTime.now().difference(compareDate).inDays;
  }

  int weekDaysAgo(DateTime other) {
    var compareDateThis = DateTime(this.year, this.month, this.day, 0, 0, 0);
    var compareDateOther =
        DateTime(other.year, other.month, other.day, 0, 0, 0);
    return compareDateThis.difference(compareDateOther).inDays;
  }
}
