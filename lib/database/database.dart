import 'package:flutter/foundation.dart';
import 'package:isa/database/daos/booksDao.dart';
import 'package:isa/database/daos/sectionsDao.dart';
import 'package:isa/models/book.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class IsaDatabase {
  // Map<String, Database> _books = {};

  // final _bookFilesStore = StoreRef<int, String>('bookFiles');
  // final _bookStore = StoreRef('book');

  final Database db;
  static String dbPath = 'isa.db';
  static DatabaseFactory dbFactory;

  IsaDatabase(this.db);

  static Future<IsaDatabase> openDatabase() async {
    if (kIsWeb) {
      dbFactory = databaseFactoryWeb;
    } else {
      dbFactory = databaseFactoryIo;
    }

    final database = await dbFactory.openDatabase(dbPath);

    _initialise(database);

    return IsaDatabase(database);
  }

  static void _initialise(Database database) async {
    final booksDao = BooksDao(database);

    final book = await booksDao.getBook();

    if (book == null) {
      booksDao.addBook(new Book('New book', 0));
    }

    final sectionsDao = SectionsDao(database);

    await sectionsDao.newSectionIfNotExists(-1);
    await sectionsDao.newSectionIfNotExists(0);
    await sectionsDao.newSectionIfNotExists(1);
  }

  // Future<List<String>> _getBookFiles() async {
  //   final records = await _bookFilesStore.find(db);

  //   if (records.isEmpty) {
  //     return [];
  //   }

  //   return records.map((r) => r.value).toList();
  // }

  // Future<Database> createBookDatabase(String title) async {
  //   var file = title + '.isa';

  //   final bookFiles = await _getBookFiles();
  //   int counter = 0;
  //   while (bookFiles.contains(file)) {
  //     file = title + counter.toString() + '.isa';
  //     counter++;
  //   }

  //   await _bookFilesStore.add(db, file);

  //   return dbFactory.openDatabase(file);
  // }

  // Future<Database> getBookDatabase(int id) async {
  //   for (var bookDb in await getBookDatabases()) {
  //     final record = await _bookStore.record('book').get(bookDb);
  //     final book = Book.fromMap(record);
  //     if (book.id == id) {
  //       return bookDb;
  //     }
  //   }
  //   return null;
  // }

  // Future<Database> _getBookDatabase(String file) async {
  //   if (_books[file] == null) {
  //     _books[file] = await dbFactory.openDatabase(file);
  //   }
  //   return _books[file];
  // }

  // Future<List<Database>> getBookDatabases() async {
  //   final bookFiles = await _getBookFiles();

  //   final books = bookFiles.map((file) async {
  //     return await _getBookDatabase(file);
  //   });
  //   return Future.wait(books);
  // }
}
