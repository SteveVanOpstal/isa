import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:isa/models/note.dart';
import 'package:random_color/random_color.dart';

class Section extends ChangeNotifier {
  int id;
  double width;
  double height;
  double scale = 1;
  String title = '';
  Color color;

  Section(
    this.id, {
    this.width,
    this.height,
    this.scale = 1,
    this.title,
    this.color,
  }) {
    RandomColor _randomColor = RandomColor();
    this.color = _randomColor.randomColor(
        colorSaturation: ColorSaturation.lowSaturation,
        colorBrightness: ColorBrightness.light);
  }

  final List<Note> _notes = [];

  UnmodifiableListView<Note> get notes => UnmodifiableListView(_notes);

  void addNote({Note note}) {
    if (note is Note) {
      _notes.add(note);
    } else {
      var newNote = Note();
      addCenter(newNote);
    }
    notifyListeners();
  }

  void addCenter(Note note) {
    note.top = this.height / 2 - note.height / 2;
    note.left = this.width / 2 - note.width / 2;
    _notes.add(note);
  }

  void remove(Note note) {
    _notes.remove(note);
    notifyListeners();
  }

  void setScale(double scale) {
    this.scale = scale;
    notifyListeners();
  }

  void setColor(Color color) {
    this.color = color;
    notifyListeners();
  }
}
