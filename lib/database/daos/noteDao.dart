import 'package:isa/database/daos/sectionsDao.dart';
import 'package:isa/database/database.dart';
import 'package:isa/models/note.dart';
import 'package:sembast/sembast.dart';

class NoteDao {
  final _database = IsaDatabase();

  final _sectionsDao = SectionsDao();
  final _bookStore = StoreRef('book');
  final _noteStore = intMapStoreFactory.store('note');

  Future<Database> _getBookDatabase(Note note) async {
    return _database.getBookDatabase(note.bookId);
  }

  void addNewNote(int bookId, int sectionId) async {
    var newNote = Note(0, bookId, sectionId, 0, 0, 200, 200, '', '');
    return addCenter(newNote);
  }

  Future<int> addNote(Note note) async {
    final bookDb = await _getBookDatabase(note);

    return await _noteStore.add(bookDb, note.toMap());
  }

  void addCenter(Note note) async {
    final bookDb = await _getBookDatabase(note);

    final book = await _sectionsDao.getSection(note.bookId, note.sectionId);
    note.top = book.height / 2 - note.height / 2;
    note.left = book.width / 2 - note.width / 2;

    _bookStore.record('note').add(bookDb, note);
  }

  Future<int> removeNote(Note note) async {
    final bookDb = await _getBookDatabase(note);

    return _noteStore.delete(bookDb,
        finder: Finder(filter: Filter.equals('id', note.id)));
  }
}
