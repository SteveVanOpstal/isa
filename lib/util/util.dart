import 'dart:ui';

import 'package:isa/models/note.dart';

class Util {
  static Offset centerPoint(Note note) {
    var dx = note.left + (note.width / 2);
    var dy = note.top + (note.height / 2);

    return Offset(dx, dy);
  }
}
