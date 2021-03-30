// import 'package:isa/database/daos/booksDao.dart';
// import 'package:isa/states/booksState.dart';
// import 'package:riverpod/riverpod.dart';

// class BooksBloc extends StateNotifier<BooksState> {
//   BooksBloc() : super(const BooksState.initializing()) {
//     init();
//   }
//   final BooksDao dataStore = new BooksDao();

//   void init() {
//     dataStore.getBooks().then((books) {
//       if (books.isEmpty) {
//         state = BooksState.booksEmpty();
//       } else {
//         state = BooksState.booksLoaded(books);
//       }
//     });
//   }
// }
