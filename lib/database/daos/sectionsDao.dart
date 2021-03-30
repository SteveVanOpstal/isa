import 'package:isa/models/section.dart';
import 'package:random_color/random_color.dart';
import 'package:sembast/sembast.dart';

class SectionsDao {
  final Database db;
  final _sectionStore = intMapStoreFactory.store('section');

  SectionsDao(this.db);

  Future<Section> getSection(int sectionId) async {
    final record = await _sectionStore.find(db,
        finder: Finder(filter: Filter.equals('id', sectionId)));

    if (record.isEmpty) {
      return null;
    }

    return Section.fromMap(record.first.value);
  }

  Future<List<Section>> getSections() async {
    final records = await _sectionStore.find(db);

    if (records.isEmpty) {
      return [];
    }

    return records.map((r) => Section.fromMap(r.value)).toList();
  }

  Stream<List<Section>> getSectionsStream() {
    final records = _sectionStore.find(db).asStream();
    return records.where((record) => record.isNotEmpty).map((records) =>
        records.map((record) => Section.fromMap(record.value)).toList());
  }

  Future<int> newSection(int sectionId) async {
    var color = RandomColor().randomColor(
        colorSaturation: ColorSaturation.lowSaturation,
        colorBrightness: ColorBrightness.light);
    final section = Section(
        id: sectionId,
        title: 'Chapter ' + (sectionId + 1).toString(),
        color: color);

    return await _sectionStore.add(db, section.toMap());
  }

  Future<int> newSectionIfNotExists(int sectionId) async {
    final section = await getSection(sectionId);

    if (section == null) {
      return await newSection(sectionId);
    }

    return sectionId;
  }

  Future<int> addSection(Section section) async {
    final sections = await getSections();
    final sectionIds = sections.map((s) => s.id);

    var newId = 0;
    while (sectionIds.contains(newId)) {
      newId++;
    }

    section.id = newId;

    return await _sectionStore.add(db, section.toMap());
  }

  Future<int> updateSection(Section section) async {
    return await _sectionStore.update(db, section.toMap(),
        finder: Finder(filter: Filter.equals('id', section.id)));
  }

  Future<int> removeSection(Section section) async {
    return await _sectionStore.delete(db,
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
