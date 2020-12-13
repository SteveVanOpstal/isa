import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:isa/models/note.dart';
import 'package:random_color/random_color.dart';

class Section extends ChangeNotifier {
  final int id;
  final int bookId;
  final double width;
  final double height;
  final double scale;
  final String title;
  final Color color;

  Section(
    this.id,
    this.bookId,
    this.width,
    this.height,
    this.scale,
    this.title,
    this.color,
  ) {
    // RandomColor _randomColor = RandomColor();
    // this.color = _randomColor.randomColor(
    //     colorSaturation: ColorSaturation.lowSaturation,
    //     colorBrightness: ColorBrightness.light);
  }

  // final List<Note> _notes = [];

  // UnmodifiableListView<Note> get notes => UnmodifiableListView(_notes);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "bookId": bookId,
      "width": width,
      "height": height,
      "scale": scale,
      "title": title,
      "color": color
    };
  }

  static Section fromMap(Map<String, dynamic> map) {
    return Section(map["id"], map["bookId"], map["width"], map["height"],
        map["scale"], map["title"], map["color"]);
  }
}
