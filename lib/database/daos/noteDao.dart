import 'package:isa/database/daos/sectionsDao.dart';
import 'package:isa/models/book.dart';
import 'package:isa/models/note.dart';
import 'package:sembast/sembast.dart';

class NoteDao {
  final Database db;
  final _noteStore = intMapStoreFactory.store('note');

  NoteDao(this.db);

  Future<List<Note>> getNotes(int sectionId) async {
    final records = await _noteStore.find(db,
        finder: Finder(filter: Filter.equals('sectionId', sectionId)));
    return records.map((r) => Note.fromMap(r.value)).toList();
  }

  void addNewNote(int sectionId) async {
    final notes = await getNotes(sectionId);
    final noteIds = notes.map((s) => s.id);

    var newId = 0;
    while (noteIds.contains(newId)) {
      newId++;
    }

    var newNote = Note(newId, sectionId, 0, 0, NOTE_WIDTH, NOTE_HEIGHT, '', '');

    return addCenter(newNote);
  }

  Future<int> addNote(Note note) async {
    return await _noteStore.add(db, note.toMap());
  }

  Future<int> updateNote(Note note) async {
    return await _noteStore.update(
      db,
      note.toMap(),
      finder: Finder(
        filter: Filter.equals('id', note.id),
      ),
    );
  }

  Future<List<int>> updateNotes(List<Note> notes) async {
    return Future.wait(
      notes.map((note) async {
        return await _noteStore.update(
          db,
          note.toMap(),
          finder: Finder(
            filter: Filter.equals('id', note.id),
          ),
        );
      }),
    );
  }

  void addCenter(Note note) async {
    final sectionsDao = SectionsDao(db);
    final section = await sectionsDao.getSection(note.sectionId);
    note.top = section.height / 2 - note.height / 2;
    note.left = section.width / 2 - note.width / 2;

    _noteStore.add(db, note.toMap());
  }

  Future<int> removeNote(Note note) async {
    return _noteStore.delete(db,
        finder: Finder(filter: Filter.equals('id', note.id)));
  }

  void centerNote(Note note) async {
    await removeNote(note);
    addCenter(note);
  }
}
