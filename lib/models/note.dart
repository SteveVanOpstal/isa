import 'package:flutter/widgets.dart';
import 'package:isa/models/book.dart';

class Note {
  final int id;
  final int sectionId;
  double left = 0;
  double top = 0;
  double width = NOTE_WIDTH;
  double height = NOTE_HEIGHT;
  String title = '';
  String note = '';

  Note(
    this.id,
    this.sectionId,
    this.left,
    this.top,
    this.width,
    this.height,
    this.title,
    this.note,
  );

  Note.clone(Note original)
      : this(original.id, original.sectionId, original.left, original.top,
            original.width, original.height, original.title, original.note);

  void setLocation(double left, double top) {
    if (left != this.left && top != this.top) {
      this.left = left;
      this.top = top;
    }
  }

  void setTitle(String title) {
    this.title = title;
  }

  void setNote(String note) {
    this.note = note;
  }

  Offset get center {
    return Offset(left + (width / 2), top + (height / 2));
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "sectionId": sectionId,
      "left": left.toInt(),
      "top": top.toInt(),
      "width": width.toInt(),
      "height": height.toInt(),
      "title": title,
      "note": note
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
        map["id"],
        map["sectionId"],
        (map["left"] as int).toDouble(),
        (map["top"] as int).toDouble(),
        (map["width"] as int).toDouble(),
        (map["height"] as int).toDouble(),
        map["title"],
        map["note"]);
  }
}
