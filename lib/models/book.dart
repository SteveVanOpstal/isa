import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isa/models/section.dart';

const CHAPTER_WIDTH = 800.0;
const CHAPTER_HEIGHT = 800.0;

class Book extends ChangeNotifier {
  final Section main = Section(-1, width: 2000, height: 800, title: '');
  final List<Section> _chapters = [];
  double _chapterScale = 0.5;

  Book() {
    addChapter();
  }

  UnmodifiableListView<Section> get chapters {
    _chapters.sort((c1, c2) => c1.id.compareTo(c2.id));
    return UnmodifiableListView(_chapters);
  }

  chapter(int index) {
    return _chapters.where((c) => c.id == index);
  }

  void addChapter() {
    var index = chapters.isEmpty ? 0 : (chapters.last.id ?? 0) + 1;
    _chapters.add(Section(index,
        width: CHAPTER_WIDTH,
        height: CHAPTER_HEIGHT,
        title: '',
        scale: this._chapterScale));
    notifyListeners();
  }

  void removeChapter(Section section) {
    _chapters.remove(section);
    notifyListeners();
  }

  void setChaptersScale(double scale) {
    this._chapterScale = scale;
    for (var chapter in _chapters) {
      chapter.setScale(scale);
    }
  }
}
