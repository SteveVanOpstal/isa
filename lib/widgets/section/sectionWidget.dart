import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isa/models/note.dart';
import 'package:isa/models/section.dart';
import 'package:isa/widgets/note/notesWidget.dart';
import 'package:isa/widgets/section/sectionHeadingWidget.dart';

import '../../bookPage.dart';

// class SectionWidget extends StatefulWidget {

//   @override
//   _SectionWidgetState createState() => _SectionWidgetState();
// }

class SectionWidget extends ConsumerWidget {
  final Section section;
  final Bounds bounds;
  final Function(Section, Note) onMove;
  final Function(Color) onColorChange;
  final double minWidth;

  const SectionWidget(this.section,
      {@required this.bounds,
      this.onMove,
      this.onColorChange,
      this.minWidth = 0.0});

  double _width(Section section, double scale) {
    var sectionWidth = section.width * scale;
    return sectionWidth < minWidth ? minWidth : sectionWidth;
  }

  double _height(Section section, double scale) {
    return section.height * scale;
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final scale = watch(scaleProvider(section.id));
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: _width(section, scale),
          height: _height(section, scale),
          child: FittedBox(
            fit: BoxFit.cover,
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: section.width,
              height: section.height,
              // child: NotesWidget(
              //   section: section,
              //   bounds: bounds,
              //   onMove: (note) {
              //     onMove(section, note);
              //   },
              // ),
            ),
          ),
        ),
        SectionHeadingWidget(
          section: section,
          onColorChange: onColorChange,
          width: _width(section, scale),
          height: _height(section, scale),
        ),
      ],
    );
  }
}
