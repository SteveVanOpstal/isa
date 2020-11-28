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
    var hslColor = HSLColor.fromColor(color);
    hslColor =
        hslColor.withLightness((hslColor.lightness + 0.1).clamp(0.0, 1.0));

    return Consumer<Note>(builder: (context, note, child) {
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
                  title: note.title.length > 0 ? Text(note.title) : null,
                  subtitle: Text(note.note),
                  onTap: () {
                    showDialog(
                      context: context,
                      child: NoteDialogWidget(note: note),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
