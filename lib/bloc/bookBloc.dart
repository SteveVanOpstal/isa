import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isa/database/daos/booksDao.dart';
import 'package:isa/models/book.dart';

// Events
abstract class BookEvent {}

class UpdateBookOffsetEvent extends BookEvent {
  final double offset;

  UpdateBookOffsetEvent(this.offset);
}

// Bloc
class BookBloc extends Bloc<BookEvent, Book> {
  var dao = BooksDao();

  BookBloc(Book book) : super(book);

  @override
  Stream<Book> mapEventToState(BookEvent event) async* {
    switch (event.runtimeType) {
      case UpdateBookOffsetEvent:
        final offset = (event as UpdateBookOffsetEvent).offset;
        final book = Book.clone(state);
        book.offset = offset;
        await dao.updateBook(book);
        yield book;
        break;
    }
  }
}
