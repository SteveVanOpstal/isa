import 'package:flutter/material.dart';
import 'package:isa/models/note.dart';
import 'package:isa/models/section.dart';
import 'package:isa/widgets/notesWidget.dart';
import 'package:isa/widgets/sectionHeadingWidget.dart';
import 'package:provider/provider.dart';

class SectionWidget extends StatefulWidget {
  final Bounds bounds;
  final Function(Section, Note) onMove;

  const SectionWidget({@required this.bounds, this.onMove});

  @override
  _SectionWidgetState createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget> {
  add(Section section, double left, double top) {
    setState(() {
      section.add();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Consumer<Section>(
        builder: (context, section, child) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: section.width * section.scale,
                height: section.height * section.scale,
                child: FittedBox(
                  fit: BoxFit.cover,
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: section.width,
                    height: section.height,
                    child: NotesWidget(
                      section: section,
                      bounds: widget.bounds,
                      onMove: (note) {
                        widget.onMove(section, note);
                      },
                    ),
                  ),
                ),
              ),
              SectionHeadingWidget(
                width: section.width * section.scale,
                height: section.height * section.scale,
                title: section.title,
                onAdd: () {
                  add(section, section.width / 2, section.height / 2);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
