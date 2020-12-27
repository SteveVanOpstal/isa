import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isa/bloc/notesBloc.dart';
import 'package:isa/bloc/sectionsBloc.dart';
import 'package:isa/widgets/notesWidget.dart';
import 'package:isa/widgets/section/sectionBackgroundWidget.dart';
import 'package:isa/widgets/section/sectionWidget.dart';
import 'package:provider/provider.dart';

import 'bloc/sectionBloc.dart';
import 'models/note.dart';
import 'models/section.dart';

class BookScreen extends StatefulWidget {
  final int bookId;

  const BookScreen(this.bookId);

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  double offset = 0;

  List<Widget> createChapters(BuildContext context, List<Section> sections) {
    List<Widget> list = [];
    for (var section in sections) {
      if (section.id < 0) {
        continue;
      }
      list.add(
        SectionWidget(
          section: section,
          bounds: Bounds(top: false, left: false, right: false),
          onMove: (source, note) {
            _move(context, sections, source, note);
          },
        ),
      );
    }
    return list;
  }

  List<Widget> createSectionBackgrounds(List<Section> sections) {
    return sections
        .map((section) => BlocProvider(
              create: (_) => SectionBloc(section),
              child: SectionBackgroundWidget(section),
            ))
        .toList();
  }

  _move(
      BuildContext context, List<Section> sections, Section source, Note note) {
    var matchedSection = _containedByChapter(sections, source, note);

    if (matchedSection is Section) {
      _moveNote(context, sections, source, matchedSection, note);
      return;
    }

    context.read<NotesBloc>().add(CenterNoteEvent(note));
  }

  Section _containedByChapter(
      List<Section> sections, Section source, Note note) {
    for (var section in sections) {
      if (_containedBySection(sections, source, section, note)) {
        return section;
      }
    }

    return null;
  }

  bool _containedBySection(
      List<Section> sections, Section source, Section target, Note note) {
    var sourceOffset = _sectionOrigin(sections, source);
    var targetOffset = _sectionOrigin(sections, target);

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

  Offset _sectionOrigin(List<Section> sections, Section subject) {
    if (subject.id < 0) {
      // main
      return Offset.zero;
    }

    double x = 0;
    for (var section in sections) {
      if (section.id > 0 && section.id < subject.id) {
        x += section.width * section.scale;
      }
    }

    final main = sections.firstWhere((section) => section.id < 0);
    return Offset(x, main.height * main.scale);
  }

  // void _centerNote(Section target, Note note) {
  //   target.remove(note);
  //   target.addCenter(note);
  // }

  void _moveNote(BuildContext context, List<Section> sections, Section source,
      Section target, Note note) {
    context.read<NotesBloc>().add(RemoveNoteEvent(note));

    var sourceOrigin = _sectionOrigin(sections, source);
    var targetOrigin = _sectionOrigin(sections, target);

    var noteCenter = note.center;

    noteCenter *= source.scale;

    noteCenter += sourceOrigin - targetOrigin;

    noteCenter /= target.scale;

    note.left = noteCenter.dx - (note.width / 2);
    note.top = noteCenter.dy - (note.height / 2);

    context.read<NotesBloc>().add(AddNoteEvent(note));
  }

  scroll(double delta) {
    // offset += delta;
    // var d = offset / 1000;

    // _book.main.setScale(1 - d);
    // _book.setChaptersScale((d / 1.5) + 0.3);
  }

  _ready(BuildContext context, SectionsState state) {
    final sections = (state as SectionsReadyState).list ?? [];
    final main = sections.firstWhere((section) => section.id < 0);

    return Stack(children: [
      Column(children: [
        SectionBackgroundWidget(
          main,
          minWidth: MediaQuery.of(context).size.width,
        ),
        Row(
          children: createSectionBackgrounds(sections),
        ),
      ]),
      Column(
        children: [
          SectionWidget(
            section: main,
            bounds: Bounds(bottom: false),
            onMove: (source, note) {
              _move(context, sections, source, note);
            },
            minWidth: MediaQuery.of(context).size.width,
          ),
          Row(
            children: [
              ...createChapters(context, sections),
              Expanded(
                child: IconButton(
                  alignment: Alignment.center,
                  icon: Icon(Icons.add),
                  onPressed: () {
                    context
                        .read<SectionsBloc>()
                        .add(AddSectionEvent(Section(id: 0, bookId: 0)));
                  },
                ),
              )
            ],
          ),
        ],
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (signal) {
        if (signal is PointerScrollEvent) {
          scroll(signal.scrollDelta.dy);
        }
      },
      child: Scaffold(
        body: BlocProvider(
          create: (_) => SectionsBloc(widget.bookId),
          child: BlocBuilder<SectionsBloc, SectionsState>(
              builder: (context, state) {
            switch (state.runtimeType) {
              case SectionsLoadingState:
                return Center(
                  child: Container(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                );
                break;
              default:
                return _ready(context, state);
                break;
            }
          }),
        ),
      ),
    );
  }
}
