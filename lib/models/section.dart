import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Section extends ChangeNotifier {
  final int id;
  final int bookId;
  final double width;
  final double height;
  final double scale;
  final String title;
  final Color color;

  Section(
      {this.id,
      this.bookId,
      this.width = 200,
      this.height = 200,
      this.scale = 1,
      this.title = '',
      this.color = Colors.blue}) {
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
      "color": color.value
    };
  }

  static Section fromMap(Map<String, dynamic> map) {
    return Section(
        id: map["id"],
        bookId: map["bookId"],
        width: map["width"],
        height: map["height"],
        scale: map["scale"],
        title: map["title"],
        color: Color(map["color"]));
  }
}
