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

class InitNotesEvent extends NotesEvent {}

class GetNotesEvent extends NotesEvent {}

class AddNoteEvent extends NotesEvent {
  final Note note;

  AddNoteEvent(this.note);
}

class AddNewNoteEvent extends NotesEvent {}

class RemoveNoteEvent extends NotesEvent {
  final Note note;

  RemoveNoteEvent(this.note);
}

class CenterNoteEvent extends NotesEvent {
  final Note note;

  CenterNoteEvent(this.note);
}

class UpdateNoteEvent extends NotesEvent {
  final Note note;

  UpdateNoteEvent(this.note);
}

class UpdateDbNoteEvent extends NotesEvent {
  final Note note;

  UpdateDbNoteEvent(this.note);
}

class UpdateNotesEvent extends NotesEvent {
  final List<Note> notes;

  UpdateNotesEvent(this.notes);
}

// Bloc
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final int bookId;
  final int sectionId;

  var dao = NoteDao();

  NotesBloc(this.bookId, this.sectionId) : super(NotesLoadingState()) {
    this.add(InitNotesEvent());
  }

  @override
  Stream<NotesState> mapEventToState(NotesEvent event) async* {
    switch (event.runtimeType) {
      case InitNotesEvent:
        yield NotesLoadingState();
        add(GetNotesEvent());
        break;
      case GetNotesEvent:
        final notes = await dao.getNotes(bookId, sectionId);
        yield NotesReadyState(notes);
        break;
      case AddNoteEvent:
        final note = (event as AddNoteEvent).note;
        await dao.addNote(note);
        add(GetNotesEvent());
        break;
      case AddNewNoteEvent:
        dao.addNewNote(bookId, sectionId);
        add(GetNotesEvent());
        break;
      case RemoveNoteEvent:
        final note = (event as RemoveNoteEvent).note;
        dao.removeNote(note);
        add(GetNotesEvent());
        break;
      case CenterNoteEvent:
        final note = (event as CenterNoteEvent).note;
        dao.centerNote(note);
        add(GetNotesEvent());
        break;
      case UpdateNoteEvent:
        final note = Note.clone((event as UpdateNoteEvent).note);
        if (state is NotesReadyState) {
          final notes = (state as NotesReadyState).notes;
          final index = notes.indexWhere((n) => n.id == note.id);
          notes[index] = note;
          yield NotesReadyState(notes);
        }
        break;
      case UpdateDbNoteEvent:
        final note = Note.clone((event as UpdateDbNoteEvent).note);
        await dao.updateNote(note);
        add(GetNotesEvent());
        break;
      case UpdateNotesEvent:
        final notes = (event as UpdateNotesEvent).notes;
        await dao.updateNotes(notes);
        add(GetNotesEvent());
        break;
      default:
        break;
    }
  }
}