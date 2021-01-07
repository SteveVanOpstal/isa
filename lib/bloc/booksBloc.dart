import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isa/database/daos/booksDao.dart';
import 'package:isa/database/daos/sectionsDao.dart';
import 'package:isa/models/book.dart';

// States
abstract class BooksState {}

class BooksLoadingState extends BooksState {}

class BooksReadyState extends BooksState {
  final List<Book> list;

  BooksReadyState(this.list);
}

// Events
abstract class BooksEvent {}

class InitBooksEvent extends BooksEvent {}

class AddBookEvent extends BooksEvent {
  final String title;

  AddBookEvent(this.title);
}

class GetBooksEvent extends BooksEvent {}

// Bloc
class BooksBloc extends Bloc<BooksEvent, BooksState> {
  var booksDao = BooksDao();
  var sectionsDao = SectionsDao();

  BooksBloc() : super(BooksLoadingState()) {
    add(InitBooksEvent());
  }

  @override
  Stream<BooksState> mapEventToState(BooksEvent event) async* {
    switch (event.runtimeType) {
      case InitBooksEvent:
        yield BooksLoadingState();
        add(GetBooksEvent());
        break;
      case AddBookEvent:
        final title = (event as AddBookEvent).title;
        final book = Book(0, title, 0);
        await booksDao.addBook(book);
        await sectionsDao.newSection(book.id, -1);
        await sectionsDao.newSection(book.id, 0);
        await sectionsDao.newSection(book.id, 1);
        yield BooksLoadingState();
        add(GetBooksEvent());
        break;
      case GetBooksEvent:
        final books = await booksDao.getBooks();
        yield BooksReadyState(books);
        break;
    }
  }
}
