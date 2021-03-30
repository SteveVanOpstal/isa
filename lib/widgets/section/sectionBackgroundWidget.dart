import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isa/bookPage.dart';
import 'package:isa/models/section.dart';

class SectionBackgroundWidget extends ConsumerWidget {
  final double minWidth;
  final Section section;

  const SectionBackgroundWidget(this.section, {this.minWidth = 0});

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
    return Container(
      margin: EdgeInsets.fromLTRB(5.0, 5.0, 2.5, 2.5),
      child: Ink(
        color: section.color,
        child: SizedBox(
          width: _width(section, scale) - 7.5,
          height: _height(section, scale) - 7.5,
        ),
      ),
    );
  }
}
