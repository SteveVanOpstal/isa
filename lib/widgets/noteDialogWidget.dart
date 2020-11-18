import 'package:flutter/material.dart';
import 'package:isa/models/note.dart';

class NoteDialogWidget extends StatelessWidget {
  final Note note;

  NoteDialogWidget({@required this.note});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        contentPadding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
        children: [
          Form(
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  initialValue: note.title,
                  decoration: InputDecoration(labelText: 'title'),
                  onFieldSubmitted: (value) {
                    Navigator.pop(context, true);
                  },
                  onChanged: (value) {
                    note.setTitle(value ?? '');
                  },
                ),
                TextFormField(
                  // expands: true,
                  // maxLines: null,
                  initialValue: note.note,
                  decoration: InputDecoration(labelText: 'note'),
                  onFieldSubmitted: (value) {
                    Navigator.pop(context, true);
                  },
                  onChanged: (value) {
                    note.setNote(value ?? '');
                  },
                ),
                ElevatedButton(
                  child: Text('submit'),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                )
              ],
            ),
          )
        ]);
  }
}
