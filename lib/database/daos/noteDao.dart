import 'package:isa/database/daos/sectionsDao.dart';
import 'package:isa/database/database.dart';
import 'package:isa/models/book.dart';
import 'package:isa/models/note.dart';
import 'package:sembast/sembast.dart';

class NoteDao {
  final _database = IsaDatabase();

  final _sectionsDao = SectionsDao();
  final _noteStore = intMapStoreFactory.store('note');

  Future<Database> _getBookDatabase(Note note) async {
    return _database.getBookDatabase(note.bookId);
  }

  Future<List<Note>> getNotes(int bookId, int sectionId) async {
    final bookDb = await _database.getBookDatabase(bookId);
    final records = await _noteStore.find(bookDb,
        finder: Finder(filter: Filter.equals('sectionId', sectionId)));
    return records.map((r) => Note.fromMap(r.value)).toList();
  }

  void addNewNote(int bookId, int sectionId) async {
    final notes = await getNotes(bookId, sectionId);
    final noteIds = notes.map((s) => s.id);

    var newId = 0;
    while (noteIds.contains(newId)) {
      newId++;
    }

    var newNote =
        Note(newId, bookId, sectionId, 0, 0, NOTE_WIDTH, NOTE_HEIGHT, '', '');

    return addCenter(newNote);
  }

  Future<int> addNote(Note note) async {
    final bookDb = await _getBookDatabase(note);

    return await _noteStore.add(bookDb, note.toMap());
  }

  Future<int> updateNote(Note note) async {
    final bookDb = await _getBookDatabase(note);

    return await _noteStore.update(
      bookDb,
      note.toMap(),
      finder: Finder(
        filter: Filter.equals('id', note.id),
      ),
    );
  }

  Future<List<int>> updateNotes(List<Note> notes) async {
    final bookDb = await _getBookDatabase(notes[0]);

    return Future.wait(
      notes.map((note) async {
        return await _noteStore.update(
          bookDb,
          note.toMap(),
          finder: Finder(
            filter: Filter.equals('id', note.id),
          ),
        );
      }),
    );
  }

  void addCenter(Note note) async {
    final bookDb = await _getBookDatabase(note);

    final section = await _sectionsDao.getSection(note.bookId, note.sectionId);
    note.top = section.height / 2 - note.height / 2;
    note.left = section.width / 2 - note.width / 2;

    _noteStore.add(bookDb, note.toMap());
  }

  Future<int> removeNote(Note note) async {
    final bookDb = await _getBookDatabase(note);

    return _noteStore.delete(bookDb,
        finder: Finder(filter: Filter.equals('id', note.id)));
  }

  void centerNote(Note note) async {
    await removeNote(note);
    addCenter(note);
  }
}
