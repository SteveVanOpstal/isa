import 'package:flutter/material.dart';
import 'package:isa/models/note.dart';
import 'package:isa/widgets/note/noteDialogWidget.dart';

class NoteWidget extends StatelessWidget {
  final Note note;
  final Function(Offset) onPan;
  final VoidCallback onPanEnd;
  final Color color;

  NoteWidget({@required this.note, this.onPan, this.onPanEnd, this.color});

  @override
  Widget build(BuildContext context) {
    var hslColor = HSLColor.fromColor(color);
    hslColor =
        hslColor.withLightness((hslColor.lightness + 0.1).clamp(0.0, 1.0));

    return Positioned(
      left: note.left,
      top: note.top,
      width: note.width,
      height: note.height,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: hslColor.toColor(),
        elevation: 5.0,
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
                color: Colors.grey[100],
                child: Icon(Icons.drag_indicator),
              ),
            ),
            Expanded(
              child: ListTile(
                title: note.title.isEmpty ? null : Text(note.title),
                subtitle:
                    Text(note.top.toString() + ', ' + note.left.toString()),
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
          ],
        ),
      ),
    );
  }
}
