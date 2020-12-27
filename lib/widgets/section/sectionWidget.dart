import 'package:flutter/material.dart';
import 'package:isa/models/note.dart';
import 'package:isa/models/section.dart';
import 'package:isa/widgets/notesWidget.dart';
import 'package:isa/widgets/section/sectionHeadingWidget.dart';

class SectionWidget extends StatefulWidget {
  final Section section;
  final Bounds bounds;
  final Function(Section, Note) onMove;
  final double minWidth;

  const SectionWidget(
      {@required this.section,
      @required this.bounds,
      this.onMove,
      this.minWidth = 0.0});

  @override
  _SectionWidgetState createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget> {
  double _width(Section section) {
    var sectionWidth = section.width * section.scale;
    return sectionWidth < widget.minWidth ? widget.minWidth : sectionWidth;
  }

  double _height(Section section) {
    return section.height * section.scale;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // SizedBox(
        //   width: _width(section),
        //   height: _height(section),
        //   child: FittedBox(
        //     fit: BoxFit.cover,
        //     alignment: Alignment.topLeft,
        //     child: SizedBox(
        //       width: section.width,
        //       height: section.height,
        //       child: NotesWidget(
        //         section: section,
        //         bounds: widget.bounds,
        //         onMove: (note) {
        //           widget.onMove(section, note);
        //         },
        //       ),
        //     ),
        //   ),
        // ),
        SectionHeadingWidget(
          section: widget.section,
          width: _width(widget.section),
          height: _height(widget.section),
        ),
      ],
    );
  }
}
