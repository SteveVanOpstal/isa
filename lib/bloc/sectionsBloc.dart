import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isa/database/daos/sectionsDao.dart';
import 'package:isa/models/section.dart';

// States
abstract class SectionsState {}

class SectionsLoadingState extends SectionsState {}

class SectionsReadyState extends SectionsState {
  final List<Section> list;

  SectionsReadyState(this.list);
}

// Events
abstract class SectionsEvent {}

class InitSectionsEvent extends SectionsEvent {
  final int bookId;

  InitSectionsEvent(this.bookId);
}

class AddSectionEvent extends SectionsEvent {
  final Section section;

  AddSectionEvent(this.section);
}

class GetSectionsEvent extends SectionsEvent {
  final int bookId;

  GetSectionsEvent(this.bookId);
}

// Bloc
class SectionsBloc extends Bloc<SectionsEvent, SectionsState> {
  var dao = SectionsDao();

  SectionsBloc(int bookId) : super(SectionsLoadingState()) {
    this.add(InitSectionsEvent(bookId));
  }

  @override
  Stream<SectionsState> mapEventToState(SectionsEvent event) async* {
    switch (event.runtimeType) {
      case InitSectionsEvent:
        yield SectionsLoadingState();
        final bookId = (event as InitSectionsEvent).bookId;
        add(GetSectionsEvent(bookId));
        break;
      case AddSectionEvent:
        yield SectionsLoadingState();
        final section = (event as AddSectionEvent).section;
        await dao.addSection(section);
        add(GetSectionsEvent(section.bookId));
        break;
      case GetSectionsEvent:
        final bookId = (event as GetSectionsEvent).bookId;
        final sections = await dao.getSections(bookId);
        yield SectionsReadyState(sections);
        break;
    }
  }
}
