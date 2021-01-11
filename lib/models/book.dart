const CHAPTER_WIDTH = 800.0;
const CHAPTER_HEIGHT = 800.0;

const NOTE_WIDTH = 200.0;
const NOTE_HEIGHT = 200.0;

class Book {
  final int id;
  final String title;
  double offset = 0;

  Book(this.id, this.title, this.offset);

  Book.clone(Book original)
      : this(original.id, original.title, original.offset);

  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "offset": offset};
  }

  static Book fromMap(Map<String, dynamic> map) {
    return Book(map["id"], map["title"], map["offset"]);
  }
}
