import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isa/models/section.dart';

class SectionList extends StateNotifier<List<Section>> {
  SectionList() : super([]);

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
