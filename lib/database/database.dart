import 'package:isa/models/book.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class IsaDatabase {
  static final IsaDatabase _singleton = IsaDatabase._internal();

  String _dbPath = 'isa.db';
  DatabaseFactory _dbFactory = databaseFactoryIo;
  Database _database;
  Map<String, Database> _books = {};

  final _bookFilesStore = StoreRef<int, String>('bookFiles');
  final _bookStore = StoreRef('book');

  factory IsaDatabase() {
    return _singleton;
  }

  IsaDatabase._internal();

  Future<Database> database() async {
    if (_database == null) {
      _database = await _dbFactory.openDatabase(_dbPath);
    }
    return _database;
  }

  Future<List<String>> _getBookFiles() async {
    final db = await database();

    final records = await _bookFilesStore.find(db);

    if (records.isEmpty) {
      return [];
    }

    return records.map((r) => r.value).toList();
  }

  Future<Database> createBookDatabase(String title) async {
    var db = await database();
    var file = title + '.isa';

    final bookFiles = await _getBookFiles();
    int counter = 0;
    while (bookFiles.contains(file)) {
      file = title + counter.toString() + '.isa';
      counter++;
    }

    await _bookFilesStore.add(db, file);

    return _dbFactory.openDatabase(file);
  }

  Future<Database> getBookDatabase(int id) async {
    for (var bookDb in await getBookDatabases()) {
      final record = await _bookStore.record('book').get(bookDb);
      final book = Book.fromMap(record.value);
      if (book.id == id) {
        return bookDb;
      }
    }
    return null;
  }

  Future<Database> _getBookDatabase(String file) async {
    if (_books[file] == null) {
      _books[file] = await _dbFactory.openDatabase(file);
    }
    return _books[file];
  }

  Future<List<Database>> getBookDatabases() async {
    final bookFiles = await _getBookFiles();

    final books = bookFiles.map((file) async {
      return await _getBookDatabase(file);
    });
    return Future.wait(books);
  }
}
