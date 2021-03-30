import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isa/bookPage.dart';
import 'package:isa/database/daos/booksDao.dart';
import 'package:isa/database/database.dart';
import 'package:riverpod/riverpod.dart';

final databaseProvider =
    Provider<IsaDatabase>((ref) => throw UnimplementedError());

final booksDaoProvider = Provider<BooksDao>((ref) {
  final database = ref.watch(databaseProvider);
  return BooksDao(database.db);
});

final currentBookProvider = StreamProvider.autoDispose((ref) {
  final booksDao = ref.watch(booksDaoProvider);
  return booksDao.getBookStream();
});

void main() async {
  final database = await IsaDatabase.openDatabase();
  runApp(ProviderScope(overrides: [
    databaseProvider.overrideWithValue(database),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BookPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text('Isa')),
//       ),
//       body: SafeArea(
//         child: Center(
//           child: BookPage(),
//         ),
//       ),
//     );
//   }
// }
