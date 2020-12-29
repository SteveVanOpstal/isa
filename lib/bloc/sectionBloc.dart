import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isa/database/daos/sectionsDao.dart';
import 'package:isa/models/section.dart';

// Events
abstract class SectionEvent {}

// class InitSectionEvent extends SectionEvent {
//   final int bookId;

//   InitSectionEvent(this.bookId);
// }

// class AddSectionEvent extends SectionEvent {
//   final Section section;

//   AddSectionEvent(this.section);
// }

class UpdateSectionColorEvent extends SectionEvent {
  final Color color;

  UpdateSectionColorEvent(this.color);
}

class UpdateSectionEvent extends SectionEvent {
  final Section section;

  UpdateSectionEvent(this.section);
}

// Bloc
class SectionBloc extends Bloc<SectionEvent, Section> {
  var dao = SectionsDao();

  SectionBloc(Section section) : super(section);

  @override
  Stream<Section> mapEventToState(SectionEvent event) async* {
    switch (event.runtimeType) {
      case UpdateSectionColorEvent:
        var color = (event as UpdateSectionColorEvent).color;
        var section = Section.clone(state);
        section.color = color;
        await dao.updateSection(section);
        yield section;
        break;
      case UpdateSectionEvent:
        var section = Section.clone((event as UpdateSectionEvent).section);
        await dao.updateSection(section);
        yield section;
        break;
    }
  }
}
