import 'package:isa/database/daos/sectionsDao.dart';
import 'package:isa/database/database.dart';
import 'package:isa/models/note.dart';
import 'package:isa/models/section.dart';
import 'package:sembast/sembast.dart';

class NoteDao {
  final _database = IsaDatabase();

  final _sectionsDao = SectionsDao();
  final _bookStore = StoreRef('book');
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

  void addNewNote(Section section) async {
    var newNote = Note(0, section.bookId, section.id, 0, 0, 200, 200, '', '');
    return addCenter(newNote);
  }

  Future<int> addNote(Note note) async {
    final bookDb = await _getBookDatabase(note);

    return await _noteStore.add(bookDb, note.toMap());
  }

  void addCenter(Note note) async {
    final bookDb = await _getBookDatabase(note);

    final section = await _sectionsDao.getSection(note.bookId, note.sectionId);
    note.top = section.height / 2 - note.height / 2;
    note.left = section.width / 2 - note.width / 2;

    _bookStore.record('note').add(bookDb, note.toMap());
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
