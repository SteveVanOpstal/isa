import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isa/bloc/bookBloc.dart';
import 'package:isa/bloc/sectionBloc.dart';
import 'package:isa/models/book.dart';
import 'package:isa/models/section.dart';

class SectionBackgroundWidget extends StatelessWidget {
  final double minWidth;

  const SectionBackgroundWidget({this.minWidth = 0});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, Book>(builder: (_, bookState) {
      return BlocBuilder<SectionBloc, Section>(builder: (context, state) {
        final offset = bookState.offset;
        return Container(
          margin: EdgeInsets.fromLTRB(5.0, 5.0, 2.5, 2.5),
          child: Ink(
            color: state.color,
            child: SizedBox(
              width: state.scaledWidth(offset, minWidth) - 7.5,
              height: state.scaledHeight(offset) - 7.5,
            ),
          ),
        );
      });
    });
  }
}
