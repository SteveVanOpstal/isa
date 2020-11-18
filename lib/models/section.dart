import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:isa/models/note.dart';

class Section extends ChangeNotifier {
  int index;
  double width;
  double height;
  double scale = 1;
  String title = '';

  Section(
    this.index, {
    this.width,
    this.height,
    this.scale = 1,
    this.title,
  });

  final List<Note> _notes = [];

  UnmodifiableListView<Note> get notes => UnmodifiableListView(_notes);

  void add({Note note}) {
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
}