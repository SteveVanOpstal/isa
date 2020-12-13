import 'package:isa/database/database.dart';
import 'package:isa/models/book.dart';
import 'package:isa/models/section.dart';
import 'package:sembast/sembast.dart';

class SectionsDao {
  final _database = IsaDatabase();
  final _sectionStore = intMapStoreFactory.store('section');

  Future<Section> getSection(int bookId, int sectionId) async {
    final bookDb = await _database.getBookDatabase(bookId);

    final record = await _sectionStore.find(bookDb,
        finder: Finder(filter: Filter.equals('id', sectionId)));
    return Section.fromMap(record.first.value);
  }

  Future<List<Section>> getSections(int bookId) async {
    final bookDb = await _database.getBookDatabase(bookId);

    final records = await _sectionStore.find(bookDb);
    return records.map((r) => Section.fromMap(r.value));
  }

  Future<int> addSection(Section section) async {
    final bookDb = await _database.getBookDatabase(section.bookId);
    // final sections = await getSections(section.bookId);
    // final sectionIds = sections.map((s) => s.id);

    // var newId = 0;
    // while (sectionIds.contains(newId)) {
    //   newId++;
    // }

    return await _sectionStore.add(bookDb, section.toMap());
  }

  Future<int> removeSection(Section section) async {
    final bookDb = await _database.getBookDatabase(section.bookId);

    return await _sectionStore.delete(bookDb,
        finder: Finder(filter: Filter.equals('id', section.id)));
  }

  // void setColor(Color color) {
  //   this.color = color;
  // }

  // void setScale(double scale) {
  //   this.scale = scale;
  //   notifyListeners();
  // }
  // void setChaptersScale(int bookId, double scale) {
  //   this._chapterScale = scale;
  //   for (var chapter in _chapters) {
  //     chapter.setScale(scale);
  //   }
  // }
}
