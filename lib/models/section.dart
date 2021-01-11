import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'book.dart';

class Section extends ChangeNotifier {
  int id;
  final int bookId;
  final double width;
  final double height;
  final String title;
  Color color;

  Section(
      {this.id,
      this.bookId,
      this.width = CHAPTER_WIDTH,
      this.height = CHAPTER_HEIGHT,
      this.title = '',
      this.color = Colors.blue});

  Section.clone(Section original)
      : this(
            id: original.id,
            bookId: original.bookId,
            width: original.width,
            height: original.height,
            title: original.title,
            color: original.color);

  double getScale(double offset) {
    var d = offset / 1000;

    if (id < 0) {
      return 1 - d;
    } else {
      return (d / 1.5) + 0.3;
    }
  }

  double scaledWidth(double offset, double minWidth) {
    var sectionWidth = width * getScale(offset);
    return sectionWidth < minWidth ? minWidth : sectionWidth;
  }

  double scaledHeight(double offset) {
    return height * getScale(offset);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "bookId": bookId,
      "width": width.toInt(),
      "height": height.toInt(),
      "title": title,
      "color": color.value
    };
  }

  static Section fromMap(Map<String, dynamic> map) {
    return Section(
        id: map["id"],
        bookId: map["bookId"],
        width: (map["width"] as int).toDouble(),
        height: (map["height"] as int).toDouble(),
        title: map["title"],
        color: Color(map["color"]));
  }
}
