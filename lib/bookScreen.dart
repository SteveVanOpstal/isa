import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isa/bloc/notesBloc.dart';
import 'package:isa/bloc/sectionBloc.dart';
import 'package:isa/bloc/sectionsBloc.dart';
import 'package:isa/widgets/notesWidget.dart';
import 'package:isa/widgets/section/sectionBackgroundWidget.dart';
import 'package:isa/widgets/section/sectionWidget.dart';
import 'package:provider/provider.dart';

import 'models/section.dart';

class BookScreen extends StatefulWidget {
  final int bookId;

  const BookScreen(this.bookId);

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  double offset = 0;

  List<Widget> createChapters(BuildContext context, List<Section> sections,
      List<SectionBloc> sectionBlocs, List<NotesBloc> notesBlocs) {
    List<Widget> list = [];
    for (var section in sections) {
      if (section.id < 0) {
        continue;
      }
      list.add(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sectionBlocs[section.id + 1]),
            BlocProvider(create: (_) => notesBlocs[section.id + 1])
          ],
          child: SectionWidget(
            bounds: Bounds(top: false, left: false, right: false),
          ),
        ),
      );
    }
    return list;
  }

  List<Widget> createChapterBackgrounds(
      List<Section> sections, List<SectionBloc> sectionBlocs) {
    return sections
        .where((section) => section.id >= 0)
        .map(
          (section) => BlocProvider(
            create: (_) => sectionBlocs[section.id + 1],
            child: SectionBackgroundWidget(),
          ),
        )
        .toList();
  }

  scroll(double delta) {
    // offset += delta;
    // var d = offset / 1000;

    // _book.main.setScale(1 - d);
    // _book.setChaptersScale((d / 1.5) + 0.3);
  }

  _ready(BuildContext context, SectionsState state) {
    final sections = (state as SectionsReadyState).list ?? [];
    // ignore: close_sinks
    final sectionBlocs = sections.map((s) => SectionBloc(s)).toList();
    final notesBlocs = sections.map((s) => NotesBloc(s.bookId, s.id)).toList();

    return Stack(children: [
      Column(children: [
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sectionBlocs[0]),
            BlocProvider(create: (_) => notesBlocs[0])
          ],
          child: SectionBackgroundWidget(
            minWidth: MediaQuery.of(context).size.width,
          ),
        ),
        Row(
          children: createChapterBackgrounds(sections, sectionBlocs),
        ),
      ]),
      Column(
        children: [
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sectionBlocs[0]),
              BlocProvider(create: (_) => notesBlocs[0])
            ],
            child: SectionWidget(
              bounds: Bounds(bottom: false),
              minWidth: MediaQuery.of(context).size.width,
            ),
          ),
          Row(
            children: [
              ...createChapters(context, sections, sectionBlocs, notesBlocs),
              Expanded(
                child: IconButton(
                  alignment: Alignment.center,
                  icon: Icon(Icons.add),
                  onPressed: () {
                    context
                        .read<SectionsBloc>()
                        .add(AddSectionEvent(Section(id: 0, bookId: 0)));
                  },
                ),
              )
            ],
          ),
        ],
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (signal) {
        if (signal is PointerScrollEvent) {
          scroll(signal.scrollDelta.dy);
        }
      },
      child: Scaffold(
        body: BlocProvider(
          create: (_) => SectionsBloc(widget.bookId),
          child: BlocBuilder<SectionsBloc, SectionsState>(
              builder: (context, state) {
            switch (state.runtimeType) {
              case SectionsLoadingState:
                return Center(
                  child: Container(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                );
                break;
              default:
                return _ready(context, state);
                break;
            }
          }),
        ),
      ),
    );
  }
}
