import 'package:isa/database/database.dart';
import 'package:isa/models/book.dart';
import 'package:sembast/sembast.dart';

class BooksDao {
  final _database = IsaDatabase();
  final _bookStore = StoreRef('book');

  addBook(Book book) async {
    final bookDb = await _database.createBookDatabase(book.title);

    await _bookStore.record('book').put(bookDb, book.toMap());
  }

  Future<int> updateBook(Book book) async {
    final bookDb = await _database.getBookDatabase(book.id);

    return await _bookStore.update(
      bookDb,
      book.toMap(),
      finder: Finder(
        filter: Filter.equals('id', book.id),
      ),
    );
  }

  Future<Book> getBook(int bookId) async {
    final bookDb = await _database.getBookDatabase(bookId);
    return _bookStore.record('book').get(bookDb);
  }

  Future<List<Book>> getBooks() async {
    final bookDbs = await _database.getBookDatabases();

    final books = bookDbs.map((bookDb) async {
      final record = await _bookStore.record('book').get(bookDb);
      return Book.fromMap(record);
    });

    return Future.wait(books);
  }
}
