import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isa/main.dart';
import 'package:isa/widgets/section/sectionBackgroundWidget.dart';
import 'package:isa/widgets/section/sectionWidget.dart';
import 'package:isa/widgets/note/notesWidget.dart';

import 'database/daos/sectionsDao.dart';
import 'models/book.dart';
import 'models/section.dart';

// class BookPage extends StatefulWidget {
//   @override
//   _BookPageState createState() => _BookPageState();
// }

final sectionsDaoProvider = Provider<SectionsDao>((ref) {
  final database = ref.watch(databaseProvider);
  return SectionsDao(database.db);
});

final currentSectionsProvider =
    StreamProvider.autoDispose<List<Section>>((ref) {
  final sectionsDao = ref.watch(sectionsDaoProvider);
  return sectionsDao.getSectionsStream();
});

// final mainProvider =
//     FutureProvider.autoDispose.family<Section, int>((ref, bookId) async {
//   final sections = await SectionsDao().getSections(bookId);
//   return sections.where((section) => section.id == -1).first;
// });

// final chaptersProvider =
//     FutureProvider.autoDispose.family<List<Section>, int>((ref, bookId) async {
//   final sections = await SectionsDao().getSections(bookId);
//   return sections.where((section) => section.id != -1);
// });

final currentSection = ScopedProvider<Section>(null);

final offsetProvider = StateProvider((ref) => 0);

final scaleProvider = Provider.family<double, int>((ref, id) {
  final offset = ref.watch(offsetProvider).state;
  var d = offset / 1000;

  if (id < 0) {
    return 1 - d;
  } else {
    return (d / 1.5) + 0.3;
  }
});

class BookPage extends ConsumerWidget {
  // final Book _book = Book();
  // double offset = 0;

  createChapters(Section main, List<Section> chapters) {
    var chapters = [];
    for (var chapter in chapters) {
      chapters.add(
        ProviderScope(
          overrides: [
            currentSection.overrideWithValue(chapter),
          ],
          child: SectionWidget(
            chapter,
            bounds: Bounds(top: false, left: false, right: false),
            onMove: (source, note) {
              // _move(main, chapters, source, note);
            },
          ),
        ),
      );
    }
    return chapters;
  }

  createChapterBackgrounds(List<Section> chapters) {
    var chapterBackgrounds = [];
    for (var chapter in chapters) {
      chapterBackgrounds.add(SectionBackgroundWidget(chapter));
    }
    return chapterBackgrounds;
  }

  // _move(Section main, List<Section> chapters, Section source, Note note) {
  //   if (_containedBySection(source, main, note)) {
  //     _moveNote(source, main, note);
  //     return;
  //   }

  //   var matchedSection = _containedByChapter(chapters, source, note);

  //   if (matchedSection is Section) {
  //     _moveNote(source, matchedSection, note);
  //     return;
  //   }

  //   _centerNote(source, note);
  // }

  // Section _containedByChapter(
  //     List<Section> chapters, Section source, Note note) {
  //   for (var i = 0; i < chapters.length; i++) {
  //     var chapter = chapters[i];
  //     if (_containedBySection(source, chapter, note)) {
  //       return chapter;
  //     }
  //   }

  //   return null;
  // }

  // bool _containedBySection(Section source, Section target, Note note) {
  //   var sourceOffset = _sectionOrigin(source);
  //   var targetOffset = _sectionOrigin(target);

  //   var noteCenter = note.center;
  //   noteCenter *= source.scale;

  //   sourceOffset += noteCenter;

  //   var top = targetOffset.dy;
  //   var bottom = top + (target.height * target.scale);
  //   var left = targetOffset.dx;
  //   var right = left + (target.width * target.scale);

  //   return sourceOffset.dx > left &&
  //       sourceOffset.dx < right &&
  //       sourceOffset.dy > top &&
  //       sourceOffset.dy < bottom;
  // }

  // Offset _sectionOrigin(Section section) {
  //   if (section.id < 0) {
  //     // main
  //     return Offset.zero;
  //   }

  //   double x = 0;
  //   for (var chapter in _book.chapters) {
  //     if (chapter.id < section.id) {
  //       x += chapter.width * chapter.scale;
  //     }
  //   }

  //   return Offset(x, _book.main.height * _book.main.scale);
  // }

  // void _centerNote(Section target, Note note) {
  //   target.remove(note);
  //   target.addCenter(note);
  // }

  // void _moveNote(Section source, Section target, Note note) {
  //   source.remove(note);

  //   var sourceOrigin = _sectionOrigin(source);
  //   var targetOrigin = _sectionOrigin(target);

  //   var noteCenter = note.center;

  //   noteCenter *= source.scale;

  //   noteCenter += sourceOrigin - targetOrigin;

  //   noteCenter /= target.scale;

  //   note.left = noteCenter.dx - (note.width / 2);
  //   note.top = noteCenter.dy - (note.height / 2);

  //   target.addNote(note: note);
  // }

  // scroll(Book book,double delta) {
  //   offset += delta;
  //   var d = offset / 1000;

  //   book.main.setScale(1 - d);
  //   book.setChaptersScale((d / 1.5) + 0.3);
  // }

  _buildSections(Book book) {
    return Consumer(builder: (context, watch, child) {
      final sectionsProvider = watch(currentSectionsProvider);
      final sectionsDao = watch(sectionsDaoProvider);

      return sectionsProvider.when(data: (sections) {
        if (sections.isEmpty) {
          return Center(child: Text('error'));
        }

        final main = sections.firstWhere((section) => section.id == -1);
        // final chapters = sections.where((section) => section.id != -1).toList();

        return Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(children: [
                  SectionBackgroundWidget(
                    main,
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  Row(children: [
                    //   ...createChapterBackgrounds(chapters),
                  ]),
                ]),
                Column(
                  children: [
                    SectionWidget(main, bounds: Bounds(bottom: false),
                        onMove: (source, note) {
                      // _move(main, chapters, source, note);
                    }, onColorChange: (color) {
                      main.color = color;
                      sectionsDao.updateSection(main);
                    }, minWidth: MediaQuery.of(context).size.width),
                    Row(children: [
                      // ...createChapters(main, chapters),
                      // Expanded(
                      //   child: IconButton(
                      //     alignment: Alignment.center,
                      //     icon: Icon(Icons.add),
                      //     onPressed: () {
                      //       // book.addChapter();
                      //     },
                      //   ),
                      // )
                    ]),
                  ],
                ),
              ],
            ),
          ),
        );
      }, loading: () {
        return CircularProgressIndicator();
      }, error: (__, _) {
        return Center(child: Text('error'));
      });
    });
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final bookProvider = watch(currentBookProvider);

    return bookProvider.when(
      data: (book) =>
          // widget.Listener(
          //   onPointerSignal: (signal) {
          //     if (signal is PointerScrollEvent) {
          //       // scroll(book, signal.scrollDelta.dy);
          //     }
          //   },
          //   child:
          _buildSections(book),
      // ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (_, __) => Container(),
    );
  }
}
