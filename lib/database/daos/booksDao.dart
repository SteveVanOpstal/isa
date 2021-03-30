import 'package:isa/models/book.dart';
import 'package:sembast/sembast.dart';

class BooksDao {
  final Database _db;
  final _bookStore = StoreRef('book');

  BooksDao(this._db);

  addBook(Book book) async {
    await _bookStore.record('book').put(_db, book.toMap());
  }

  Future<int> updateBook(Book book) async {
    return await _bookStore.update(
      _db,
      book.toMap(),
      finder: Finder(
        filter: Filter.equals('id', book),
      ),
    );
  }

  Future<Book> getBook() async {
    final record = await _bookStore.record('book').get(_db);

    if (record == null) {
      return null;
    }

    return Book.fromMap(record);
  }

  Stream<Book> getBookStream() {
    return _bookStore.record('book').onSnapshot(_db).map((record) {
      return Book.fromMap(record.value);
    });
  }

  // Stream<List<Book>> getBooks() async {
  //   final bookDbs = await _database.getBookDatabases();

  //   final books = bookDbs.map((bookDb) {
  //     return _bookStore.record('book').onSnapshot(bookDb);
  //   }).map((record) {
  //     return record.map((event) => Book.fromMap(event.value));
  //   });

  //   return CombineLatestStream.list(books);
  // }
}
