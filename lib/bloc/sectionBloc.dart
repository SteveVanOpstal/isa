import 'package:flutter_bloc/flutter_bloc.dart';
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

// class GetSectionEvent extends SectionEvent {
//   final int bookId;

//   GetSectionEvent(this.bookId);
// }

// Bloc
class SectionBloc extends Bloc<SectionEvent, Section> {
  SectionBloc(Section section) : super(section);

  @override
  Stream<Section> mapEventToState(SectionEvent event) async* {
    // switch (event.runtimeType) {

    // }
  }
}
