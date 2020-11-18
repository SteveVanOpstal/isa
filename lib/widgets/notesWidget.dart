import 'package:flutter/material.dart';
import 'package:isa/models/note.dart';
import 'package:isa/models/section.dart';
import 'package:isa/util/util.dart';
import 'package:isa/widgets/noteWidget.dart';

import 'dart:math' as math;

import 'package:provider/provider.dart';

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
  _NotesWidgetState createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    controller.addListener(() => {
          setState(() {
            _animate(widget.section);
          })
        });
    super.initState();
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(NotesWidget oldWidget) {
    controller.reset();
    controller.forward();
    super.didUpdateWidget(oldWidget);
  }

  void _pan(Section section, Note note, Offset offset) {
    note.left += offset.dx;
    note.top += offset.dy;

    _setBoundaries(section, note);
  }

  void _animate(Section section) {
    if (!_noteForce(section) && !_sectionsForce(section)) {
      controller.stop();
    } else {
      for (var note in section.notes) {
        note.setLocation(note.left, note.top);
      }
    }
  }

  bool _noteForce(Section section) {
    if (section.notes.isEmpty) {
      return false;
    }

    var radius = section.notes[0].width;
    var changes = false;
    var random = math.Random();

    for (var i = 0; i < section.notes.length; i++) {
      var note = section.notes[i];
      var noteOffset = Util.centerPoint(note);

      for (var j = 0; j < section.notes.length; j++) {
        if (i == j) {
          continue;
        }

        var n = section.notes[j];
        var nOffset = Util.centerPoint(n);

        var vector = (noteOffset - nOffset);
        var distance = vector.distance;
        var direction = vector.direction;

        if (distance < radius) {
          double force = ((radius - distance) * 0.05) + random.nextInt(5);
          note.left += force * math.cos(direction);
          note.top += force * math.sin(direction);
          changes = true;

          _setBoundaries(section, note);
        }
      }
    }

    return changes;
  }

  bool _sectionsForce(Section section) {
    var changes = [];

    for (var i = 0; i < section.notes.length; i++) {
      var note = section.notes[i];
      changes.add(_sectionForce(note, section));
    }

    return changes.any((c) => c);
  }

  bool _sectionForce(Note note, Section section,
      {Offset offset = Offset.zero}) {
    var changes = false;
    var random = math.Random();

    var center = Util.centerPoint(note);

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
    var center = Util.centerPoint(note);
    return _outOfBoundsTop(center.dx) ||
        _outOfBoundsLeft(center.dy) ||
        _outOfBoundsRight(section, center.dx) ||
        _outOfBoundsBottom(section, center.dy);
  }

  createNoteWidgets(Section section) {
    List<Widget> notes = [];
    for (var note in section.notes) {
      notes.add(
        ChangeNotifierProvider.value(
          value: note,
          child: NoteWidget(onPan: (offset) {
            setState(() {
              _pan(section, note, offset);
            });
          }, onPanEnd: () {
            if (_outOfBounds(section, note)) {
              widget.onMove(note);
            } else {
              controller.reset();
              controller.forward();
            }
          }),
        ),
      );
    }
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Section>(
      builder: (context, section, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: createNoteWidgets(section),
        );
      },
    );
  }
}
