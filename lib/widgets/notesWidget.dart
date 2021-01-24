import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isa/bloc/notesBloc.dart';
import 'package:isa/bloc/sectionBloc.dart';
import 'package:isa/models/note.dart';
import 'package:isa/models/section.dart';
import 'package:isa/widgets/note/noteWidget.dart';

import 'dart:math' as math;

class Bounds {
  bool top = true;
  bool right = true;
  bool bottom = true;
  bool left = true;

  Bounds(
      {this.top = true,
      this.right = true,
      this.bottom = true,
      this.left = true});
}

class NotesWidget extends StatefulWidget {
  final Section section;
  final Bounds bounds;
  final Function(Note) onMove;

  const NotesWidget(
      {Key key, @required this.section, @required this.bounds, this.onMove})
      : super(key: key);

  @override
  NotesWidgetState createState() => NotesWidgetState();
}

class NotesWidgetState extends State<NotesWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    super.initState();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(NotesWidget oldWidget) {
    _controller.reset();
    _controller.forward();
    super.didUpdateWidget(oldWidget);
  }

  void _pan(Section section, Note note, Offset offset) {
    note.left += offset.dx;
    note.top += offset.dy;

    _setBoundaries(section, note);
  }

  void _animate(BuildContext context, List<Note> notes) {
    final section = context.read<SectionBloc>().state;
    if (!_noteForce(section, notes) && !_sectionsForce(section, notes)) {
      _controller.stop();
    } else {
      for (var note in notes) {
        note.setLocation(note.left, note.top);
      }
      context.read<NotesBloc>().add(UpdateNotesEvent(notes));
    }
  }

  bool _noteForce(Section section, notes) {
    if (notes.isEmpty) {
      return false;
    }

    var radius = notes[0].width;
    var changes = false;
    var random = math.Random();

    for (var i = 0; i < notes.length; i++) {
      var note = notes[i];

      for (var j = 0; j < notes.length; j++) {
        if (i == j) {
          continue;
        }

        var vector = (note.center - notes[j].center);
        var distance = vector.distance;
        var direction = vector.direction;

        if (distance < radius) {
          double force =
              ((radius - distance) * 0.005) + (random.nextInt(5) / 100);
          note.left += force * math.cos(direction);
          note.top += force * math.sin(direction);
          changes = true;

          _setBoundaries(section, note);
        }
      }
    }

    return changes;
  }

  bool _sectionsForce(Section section, notes) {
    var changes = [];

    for (var note in notes) {
      changes.add(_sectionForce(note, section));
    }

    return changes.any((c) => c);
  }

  bool _sectionForce(Note note, Section section,
      {Offset offset = Offset.zero}) {
    var changes = false;
    var random = math.Random();

    var center = note.center;

    if (note.left < offset.dx && center.dx > offset.dx) {
      note.left += ((offset.dx - note.left) * 0.05) + random.nextInt(5);
      changes = true;
    }

    if (note.top < offset.dy && center.dy > offset.dy) {
      note.top += ((offset.dy - note.top) * 0.05) + random.nextInt(5);
      changes = true;
    }

    var right = note.left + note.width;
    var sectionRight = offset.dx + section.width;
    if (right > sectionRight && center.dx < sectionRight) {
      note.left -= ((right - sectionRight) * 0.05) + random.nextInt(5);
      changes = true;
    }

    var bottom = note.top + note.height;
    var sectionBottom = offset.dy + section.height;
    if (bottom > sectionBottom && center.dy < sectionBottom) {
      note.top -= ((bottom - sectionBottom) * 0.05) + random.nextInt(5);
      changes = true;
    }

    return changes;
  }

  void _setBoundaries(Section section, Note note) {
    if (widget.bounds.top && _outOfBoundsTop(note.top)) {
      note.top = 0;
    }

    if (widget.bounds.left && _outOfBoundsLeft(note.left)) {
      note.left = 0;
    }

    if (widget.bounds.right &&
        _outOfBoundsRight(section, note.left + note.width)) {
      note.left = section.width - note.width;
    }

    if (widget.bounds.bottom &&
        _outOfBoundsBottom(section, note.top + note.height)) {
      note.top = section.height - note.height;
    }
  }

  bool _outOfBoundsTop(double x) {
    return x <= 0;
  }

  bool _outOfBoundsLeft(double y) {
    return y <= 0;
  }

  bool _outOfBoundsRight(Section section, double x) {
    var sectionRight = section.width;
    return x > sectionRight;
  }

  bool _outOfBoundsBottom(Section section, double y) {
    var sectionBottom = section.height;
    return y > sectionBottom;
  }

  bool _outOfBounds(Section section, Note note) {
    var center = note.center;
    return _outOfBoundsTop(center.dx) ||
        _outOfBoundsLeft(center.dy) ||
        _outOfBoundsRight(section, center.dx) ||
        _outOfBoundsBottom(section, center.dy);
  }

  void _checkNotesOutOfBounds(List<Note> notes) {
    for (var note in notes) {
      if (_outOfBounds(widget.section, note)) {
        widget.onMove(note);
      }
    }
  }

  createNoteWidgets(BuildContext context, Section section, List<Note> notes) {
    List<Widget> list = [];
    for (var note in notes) {
      Listenable animation = Tween().animate(_controller);
      list.add(
        AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              animation.addListener(() {
                _checkNotesOutOfBounds(notes);
                _animate(context, notes);
              });
              return NoteWidget(
                  note: note,
                  color: section.color,
                  onPan: (offset) {
                    _pan(section, note, offset);
                    context.read<NotesBloc>().add(UpdateNoteEvent(note));
                  },
                  onPanEnd: () {
                    _checkNotesOutOfBounds(notes);
                    context.read<NotesBloc>().add(UpdateDbNoteEvent(note));
                    _controller.reset();
                    _controller.forward();
                  });
            }),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(builder: (context, state) {
      switch (state.runtimeType) {
        case NotesLoadingState:
          return Center(
            child: Container(
              height: 20.0,
              width: 20.0,
              child: CircularProgressIndicator(),
            ),
          );
          break;
        default:
          final notes = (state as NotesReadyState).notes ?? [];
          return Stack(
            clipBehavior: Clip.none,
            children: createNoteWidgets(context, widget.section, notes),
          );
          break;
      }
    });
  }
}
