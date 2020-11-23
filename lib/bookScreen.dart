import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:isa/widgets/section/sectionBackgroundWidget.dart';
import 'package:isa/widgets/section/sectionWidget.dart';
import 'package:isa/widgets/notesWidget.dart';
import 'package:provider/provider.dart';

import 'models/book.dart';
import 'models/note.dart';
import 'models/section.dart';

class BookScreen extends StatefulWidget {
  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final Book _book = Book();

  createChapters() {
    var chapters = [];
    for (var chapter in _book.chapters) {
      chapters.add(
        ChangeNotifierProvider.value(
          value: chapter,
          child: SectionWidget(
            bounds: Bounds(top: false, left: false, right: false),
            onMove: (source, note) {
              _move(source, note);
            },
          ),
        ),
      );
    }
    return chapters;
  }

  createChapterBackgrounds() {
    var chapters = [];
    for (var chapter in _book.chapters) {
      chapters.add(
        ChangeNotifierProvider.value(
          value: chapter,
          child: SectionBackgroundWidget(chapter),
        ),
      );
    }
    return chapters;
  }

  _move(Section source, Note note) {
    if (_containedBySection(source, _book.main, note)) {
      _moveNote(source, _book.main, note);
      return;
    }

    var matchedSection = _containedByChapter(source, note);

    if (matchedSection is Section) {
      _moveNote(source, matchedSection, note);
      return;
    }

    _centerNote(source, note);
  }

  Section _containedByChapter(Section source, Note note) {
    for (var i = 0; i < _book.chapters.length; i++) {
      var chapter = _book.chapters[i];
      if (_containedBySection(source, chapter, note)) {
        return chapter;
      }
    }

    return null;
  }

  bool _containedBySection(Section source, Section target, Note note) {
    var sourceOffset = _sectionOrigin(source);
    var targetOffset = _sectionOrigin(target);

    var noteCenter = note.center;
    noteCenter *= source.scale;

    sourceOffset += noteCenter;

    var top = targetOffset.dy;
    var bottom = top + (target.height * target.scale);
    var left = targetOffset.dx;
    var right = left + (target.width * target.scale);

    return sourceOffset.dx > left &&
        sourceOffset.dx < right &&
        sourceOffset.dy > top &&
        sourceOffset.dy < bottom;
  }

  Offset _sectionOrigin(Section section) {
    if (section.index < 0) {
      // main
      return Offset.zero;
    }

    double x = 0;
    for (var chapter in _book.chapters) {
      if (chapter.index < section.index) {
        x += chapter.width * chapter.scale;
      }
    }

    return Offset(x, _book.main.height * _book.main.scale);
  }

  void _centerNote(Section target, Note note) {
    target.remove(note);
    target.addCenter(note);
  }

  void _moveNote(Section source, Section target, Note note) {
    source.remove(note);

    var sourceOrigin = _sectionOrigin(source);
    var targetOrigin = _sectionOrigin(target);

    var noteCenter = note.center;

    noteCenter *= source.scale;

    noteCenter += sourceOrigin - targetOrigin;

    noteCenter /= target.scale;

    note.left = noteCenter.dx - (note.width / 2);
    note.top = noteCenter.dy - (note.height / 2);

    target.addNote(note: note);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _book,
      child: Scaffold(
        body: Stack(children: [
          Column(children: [
            ChangeNotifierProvider.value(
              value: _book.main,
              child: SectionBackgroundWidget(
                _book.main,
                minWidth: MediaQuery.of(context).size.width,
              ),
            ),
            Consumer<Book>(builder: (context, book, child) {
              return Row(children: [
                ...createChapterBackgrounds(),
              ]);
            })
          ]),
          Column(children: [
            ChangeNotifierProvider.value(
              value: _book.main,
              child: SectionWidget(
                bounds: Bounds(bottom: false),
                onMove: (source, note) {
                  _move(source, note);
                },
                minWidth: MediaQuery.of(context).size.width,
              ),
            ),
            Consumer<Book>(
              builder: (context, book, child) {
                return Row(children: [
                  ...createChapters(),
                  Expanded(
                    child: IconButton(
                      alignment: Alignment.center,
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _book.addChapter();
                      },
                    ),
                  )
                ]);
              },
            ),
          ]),
        ]),
      ),
    );
  }
}
