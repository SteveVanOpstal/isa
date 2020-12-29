import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isa/bloc/sectionBloc.dart';
import 'package:isa/models/section.dart';

class SectionBackgroundWidget extends StatelessWidget {
  final double minWidth;

  const SectionBackgroundWidget({this.minWidth = 0});

  double _width(Section section) {
    var sectionWidth = section.width * section.scale;
    return sectionWidth < minWidth ? minWidth : sectionWidth;
  }

  double _height(Section section) {
    return section.height * section.scale;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SectionBloc, Section>(builder: (context, state) {
      return Container(
        margin: EdgeInsets.fromLTRB(5.0, 5.0, 2.5, 2.5),
        child: Ink(
          color: state.color,
          child: SizedBox(
            width: _width(state) - 7.5,
            height: _height(state) - 7.5,
          ),
        ),
      );
    });
  }
}
