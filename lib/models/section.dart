import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Section extends ChangeNotifier {
  int id;
  final int bookId;
  final double width;
  final double height;
  final double scale;
  final String title;
  Color color;

  Section(
      {this.id,
      this.bookId,
      this.width = 600,
      this.height = 600,
      this.scale = 1,
      this.title = '',
      this.color = Colors.blue});

  Section.clone(Section original)
      : this(
            id: original.id,
            bookId: original.bookId,
            width: original.width,
            height: original.height,
            scale: original.scale,
            title: original.title,
            color: original.color);

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
