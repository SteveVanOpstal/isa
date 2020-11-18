import 'package:flutter/widgets.dart';

class Note extends ChangeNotifier {
  double left = 0;
  double top = 0;
  double width = 200;
  double height = 200;
  String title = '';
  String note = '';

  Note({
    this.left = 0,
    this.top = 0,
    this.width = 200,
    this.height = 200,
    this.title = '',
    this.note = '',
  });

  void setLocation(double left, double top) {
    if (left != this.left && top != this.top) {
      this.left = left;
      this.top = top;
      notifyListeners();
    }
  }

  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  void setNote(String note) {
    this.note = note;
    notifyListeners();
  }
}
