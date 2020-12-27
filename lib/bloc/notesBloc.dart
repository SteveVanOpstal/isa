import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isa/database/daos/noteDao.dart';
import 'package:isa/models/note.dart';

// // States
abstract class NotesState {}

class NotesLoadingState extends NotesState {}

class NotesReadyState extends NotesState {
  final List<Note> notes;

  NotesReadyState(this.notes);
}

// Events
abstract class NotesEvent {}

class InitNotesEvent extends NotesEvent {
  final int bookId;
  final int sectionId;

  InitNotesEvent(this.sectionId, this.bookId);
}

class GetNotesEvent extends NotesEvent {
  final int bookId;
  final int sectionId;

  GetNotesEvent(this.sectionId, this.bookId);
}

class AddNoteEvent extends NotesEvent {
  final Note note;

  AddNoteEvent(this.note);
}

class RemoveNoteEvent extends NotesEvent {
  final Note note;

  RemoveNoteEvent(this.note);
}

class CenterNoteEvent extends NotesEvent {
  final Note note;

  CenterNoteEvent(this.note);
}

// Bloc
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  var dao = NoteDao();

  NotesBloc() : super(NotesLoadingState());

  @override
  Stream<NotesState> mapEventToState(NotesEvent event) async* {
    switch (event.runtimeType) {
      case InitNotesEvent:
        yield NotesLoadingState();
        final bookId = (event as InitNotesEvent).bookId;
        final sectionId = (event as InitNotesEvent).sectionId;
        add(GetNotesEvent(bookId, sectionId));
        break;
      case GetNotesEvent:
        final bookId = (event as InitNotesEvent).bookId;
        final sectionId = (event as InitNotesEvent).sectionId;
        final notes = await dao.getNotes(bookId, sectionId);
        yield NotesReadyState(notes);
        break;
      case AddNoteEvent:
        final note = (event as AddNoteEvent).note;
        await dao.addNote(note);
        break;
      case RemoveNoteEvent:
        final note = (event as RemoveNoteEvent).note;
        dao.removeNote(note);
        break;
      case CenterNoteEvent:
        final note = (event as CenterNoteEvent).note;
        dao.centerNote(note);
        break;
      default:
        break;
    }
  }
}
