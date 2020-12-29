import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isa/database/daos/noteDao.dart';
import 'package:isa/models/note.dart';

// Events
abstract class NoteEvent {}

// class InitNoteEvent extends NoteEvent {
//   final int bookId;

//   InitNoteEvent(this.bookId);
// }

// class AddNoteEvent extends NoteEvent {
//   final Note Note;

//   AddNoteEvent(this.Note);
// }

class UpdateNoteColorEvent extends NoteEvent {
  final Color color;

  UpdateNoteColorEvent(this.color);
}

class UpdateNoteEvent extends NoteEvent {
  final Note note;

  UpdateNoteEvent(this.note);
}

// Bloc
class NoteBloc extends Bloc<NoteEvent, Note> {
  var dao = NoteDao();

  NoteBloc(Note note) : super(note);

  @override
  Stream<Note> mapEventToState(NoteEvent event) async* {
    switch (event.runtimeType) {
      case UpdateNoteEvent:
        final note = Note.clone((event as UpdateNoteEvent).note);
        await dao.updateNote(note);
        yield note;
        break;
    }
  }
}
