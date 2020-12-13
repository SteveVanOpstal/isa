import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isa/database/database.dart';
import 'package:isa/models/book.dart';

class BookFile {
  final String name;

  BookFile(this.name);
}

// States
abstract class BooksState {}

class BooksLoadingState extends BooksState {}

class BooksEmptyState extends BooksState {}

class BooksReadyState extends BooksState {
  final List<BookFile> list;

  BooksReadyState(this.list);
}

// Events
abstract class BooksEvent {}

class InitBooksEvent extends BooksEvent {}

class AddBookEvent extends BooksEvent {
  final String name;

  AddBookEvent(this.name);
}

class GetBooksEvent extends BooksEvent {}

// Bloc
class BooksBloc extends Bloc<BooksEvent, BooksState> {
  var db = IsaDatabase();

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
        await db.createBookDatabase((event as AddBookEvent).name);
        yield BooksLoadingState();
        add(GetBooksEvent());
        break;
      case GetBooksEvent:
        final books = await db.getBooks();

        if (books.isEmpty) {
          yield BooksEmptyState();
        } else {
          yield BooksReadyState(books);
        }
        break;
    }
  }
}
