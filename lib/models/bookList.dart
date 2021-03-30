import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isa/models/book.dart';

class BookList extends StateNotifier<List<Book>> {
  BookList() : super([]);

  // void add(String description) {
  //   state = [
  //     ...state,
  //     Book(
  //       id: _uuid.v4(),
  //       description: description,
  //     ),
  //   ];
  // }

  // void remove(Todo target) {
  //   state = state.where((todo) => todo.id != target.id).toList();
  // }
}
