import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isa/models/section.dart';

const CHAPTER_WIDTH = 800.0;
const CHAPTER_HEIGHT = 800.0;

class Book {
  final int id;
  final String title;
  final double scrollOffset;

  Book(this.id, this.title, this.scrollOffset);

  // final Section main = Section(-1, width: 2000, height: 800, title: '');
  // final List<Section> _chapters = [];
  // UnmodifiableListView<Section> get chapters {
  //   _chapters.sort((c1, c2) => c1.id.compareTo(c2.id));
  //   return UnmodifiableListView(_chapters);
  // }

  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "scrollOffset": scrollOffset};
  }

  static Book fromMap(Map<String, dynamic> map) {
    return Book(map["id"], map["title"], map["scrollOffset"]);
  }
}
