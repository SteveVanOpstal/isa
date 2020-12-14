import 'package:flutter/widgets.dart';

class Note extends ChangeNotifier {
  final int id;
  final int bookId;
  final int sectionId;
  double left = 0;
  double top = 0;
  double width = 200;
  double height = 200;
  String title = '';
  String note = '';

  Note(
    this.id,
    this.bookId,
    this.sectionId,
    this.left,
    this.top,
    this.width,
    this.height,
    this.title,
    this.note,
  );

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
      "bookId": bookId,
      "sectionId": sectionId,
      "left": left,
      "top": top,
      "width": width,
      "height": height,
      "title": title,
      "note": note
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(map["id"], map["bookId"], map["sectionId"], map["left"],
        map["top"], map["width"], map["height"], map["title"], map["note"]);
  }
}
