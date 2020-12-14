import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isa/database/daos/booksDao.dart';
import 'package:isa/database/database.dart';
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
  var dao = BooksDao();

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
        await dao.addBook(book);
        yield BooksLoadingState();
        add(GetBooksEvent());
        break;
      case GetBooksEvent:
        final books = await dao.getBooks();
        yield BooksReadyState(books);
        break;
    }
  }
}
