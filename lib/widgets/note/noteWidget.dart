import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isa/bloc/noteBloc.dart';
import 'package:isa/models/note.dart';
import 'package:isa/widgets/note/noteDialogWidget.dart';

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

    return BlocBuilder<NoteBloc, Note>(builder: (context, state) {
      return Positioned(
        left: state.left,
        top: state.top,
        width: state.width,
        height: state.height,
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
                  title: state.title.isEmpty ? null : Text(state.title),
                  subtitle: Text(state.note),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return NoteDialogWidget(note: state);
                      },
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
