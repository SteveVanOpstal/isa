import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isa/bloc/bookBloc.dart';
import 'package:isa/bloc/notesBloc.dart';
import 'package:isa/bloc/sectionBloc.dart';
import 'package:isa/bloc/sectionsBloc.dart';
import 'package:isa/models/book.dart';
import 'package:isa/models/note.dart';
import 'package:isa/models/section.dart';
import 'package:isa/widgets/notesWidget.dart';
import 'package:isa/widgets/section/sectionHeadingWidget.dart';

class SectionWidget extends StatefulWidget {
  final Bounds bounds;
  final double minWidth;

  const SectionWidget({@required this.bounds, this.minWidth = 0.0});

  @override
  _SectionWidgetState createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget> {
  double offset = 0.0;

  _move(BuildContext context, Section source, Note note) {
    final sections =
        (context.read<SectionsBloc>().state as SectionsReadyState).list;
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
    noteCenter *= source.getScale(offset);

    sourceOffset += noteCenter;

    var top = targetOffset.dy;
    var bottom = top + (target.height * target.getScale(offset));
    var left = targetOffset.dx;
    var right = left + (target.width * target.getScale(offset));

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
        x += section.width * section.getScale(offset);
      }
    }

    final main = sections.firstWhere((section) => section.id < 0);
    return Offset(x, main.height * main.getScale(offset));
  }

  void _moveNote(BuildContext context, List<Section> sections, Section source,
      Section target, Note note) {
    context.read<NotesBloc>().add(RemoveNoteEvent(note));

    var sourceOrigin = _sectionOrigin(sections, source);
    var targetOrigin = _sectionOrigin(sections, target);

    var noteCenter = note.center;

    noteCenter *= source.getScale(offset);

    noteCenter += sourceOrigin - targetOrigin;

    noteCenter /= target.getScale(offset);

    note.left = noteCenter.dx - (note.width / 2);
    note.top = noteCenter.dy - (note.height / 2);

    context.read<NotesBloc>().add(AddNoteEvent(note));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, Book>(builder: (_, bookState) {
      return BlocBuilder<SectionBloc, Section>(builder: (context, state) {
        offset = bookState.offset;
        final width = state.scaledWidth(offset, widget.minWidth);
        final height = state.scaledHeight(offset);
        return Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: width,
              height: height,
              child: FittedBox(
                fit: BoxFit.cover,
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: state.width,
                  height: state.height,
                  child: NotesWidget(
                    section: state,
                    bounds: widget.bounds,
                    onMove: (note) {
                      _move(context, state, note);
                    },
                  ),
                ),
              ),
            ),
            SectionHeadingWidget(
              section: state,
              width: width,
              height: height,
            ),
          ],
        );
      });
    });
  }
}
