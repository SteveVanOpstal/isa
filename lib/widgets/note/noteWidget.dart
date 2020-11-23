import 'package:flutter/material.dart';
import 'package:isa/models/note.dart';
import 'package:isa/widgets/note/noteDialogWidget.dart';
import 'package:provider/provider.dart';

class NoteWidget extends StatelessWidget {
  final Function(Offset) onPan;
  final VoidCallback onPanEnd;
  final Color color;

  NoteWidget({this.onPan, this.onPanEnd, this.color});

  @override
  Widget build(BuildContext context) {
    return Consumer<Note>(builder: (context, note, child) {
      return Positioned(
        left: note.left,
        top: note.top,
        width: note.width,
        height: note.height,
        child: Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onPanUpdate: (details) {
                  onPan(details.delta);
                },
                onPanEnd: (details) {
                  onPanEnd();
                },
                child: Container(
                  color: Colors.grey[400],
                  child: Icon(Icons.drag_indicator),
                ),
              ),
              Expanded(
                child: Container(
                  color: color,
                  child: ListTile(
                    title: note.title.length > 0 ? Text(note.title) : null,
                    subtitle: Text(note.note),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return NoteDialogWidget(note: note);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
