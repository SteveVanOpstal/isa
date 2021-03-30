// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:isa/bookPage.dart';
// import 'package:isa/database/daos/booksDao.dart';
// import 'package:isa/main.dart';
// import 'package:isa/models/bookList.dart';
// import 'package:sembast/sembast.dart';

// import 'database/database.dart';
// import 'models/book.dart';

// // final booksProvider = FutureProvider<List<Book>>((ref) async {
// //   return await BooksDao().getBooks();
// // });

// // final bookListProvider = StateNotifierProvider<BookList>((ref) {
// //   return BookList();
// // });

// // // final booksProvider = Provider<List<Book>>((ref) {
// // //   return ref.watch(bookListProvider.state).toList();
// // // });

// // final currentFileProvider = StateProvider((ref) => null);

// // final currentBookProvider = ScopedProvider<Book>(null);

// // final booksDao = new BooksDao();

// // final createBookProvider = FutureProvider.autoDispose<Book>((ref) async {
// //   return ;
// // });

// final bookProvider = StreamProvider.autoDispose.family<Database, Book>((ref) {
//   database.db;
//   if (profilesData?.selectedId != null) {
//     return dataStore.favouriteMovie(
//         profileId: profilesData.selectedId, movie: movie);
//   }
//   return Stream.empty();
// });

// class BooksView extends ConsumerWidget {
//   _createBookButtons(BuildContext context, List<Book> books) {
//     return books.map((book) => () {
//           return TextButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     PageRouteBuilder(
//                       opaque: false,
//                       pageBuilder: (BuildContext context, _, __) {
//                         return ProviderScope(
//                           overrides: [
//                             currentBookProvider.overrideWithValue(book),
//                           ],
//                           child: BookPage(),
//                         );
//                       },
//                     ));
//               },
//               child: Text(book.title));
//         });
//   }

//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     final database = watch(databaseProvider);
//     // List<Book> books = watch(booksProvider);

//     return booksProvider.when(data: (books) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           ..._createBookButtons(context, books),
//           FloatingActionButton(
//             child: Icon(Icons.add),
//             onPressed: () async {
//               var book = new Book('new book', 0);

//               await booksDao.addBook(book);

//               return Navigator.push(
//                   context,
//                   PageRouteBuilder(
//                     opaque: false,
//                     pageBuilder: (BuildContext context, _, __) {
//                       return ProviderScope(overrides: [
//                         currentBookProvider.overrideWithValue(book),
//                       ], child: BookPage());
//                     },
//                   ));
//             },
//           ),
//         ],
//       );
//     }, loading: () {
//       return CircularProgressIndicator();
//     }, error: (__, _) {
//       return Center(child: Text('error'));
//     });
//   }
// }
