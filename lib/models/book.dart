import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isa/models/section.dart';

class Book extends ChangeNotifier {
  final main = Section(-1, width: 1500, height: 500, title: '');
  final List<Section> _chapters = [
    Section(0, width: 500, height: 500, title: '', scale: 0.5)
  ];

  UnmodifiableListView<Section> get chapters {
    _chapters.sort((c1, c2) => c1.index.compareTo(c2.index));
    return UnmodifiableListView(_chapters);
  }

  chapter(int index) {
    return _chapters.where((c) => c.index == index);
  }

  void addChapter() {
    var index = (chapters.last.index ?? 0) + 1;
    _chapters.add(Section(index, width: 500, height: 500, title: '', scale: 0.5));
    notifyListeners();
  }

  void removeChapter(Section section) {
    _chapters.remove(section);
    notifyListeners();
  }
}
