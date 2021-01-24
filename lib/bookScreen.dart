import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isa/bloc/bookBloc.dart';
import 'package:isa/bloc/booksBloc.dart';
import 'package:isa/bloc/notesBloc.dart';
import 'package:isa/bloc/sectionBloc.dart';
import 'package:isa/bloc/sectionsBloc.dart';
import 'package:isa/widgets/notesWidget.dart';
import 'package:isa/widgets/section/sectionBackgroundWidget.dart';
import 'package:isa/widgets/section/sectionWidget.dart';
import 'package:provider/provider.dart';

import 'models/book.dart';
import 'models/section.dart';

class BookScreen extends StatefulWidget {
  final int bookId;

  const BookScreen(this.bookId);

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  double offset = 0;

  List<Widget> createChapters(BuildContext context,
      List<SectionBloc> sectionBlocs, List<NotesBloc> notesBlocs) {
    List<Widget> list = [];
    for (var sectionBloc in sectionBlocs) {
      if (sectionBloc.state.id < 0) {
        continue;
      }
      list.add(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sectionBloc),
            BlocProvider(create: (_) => notesBlocs[sectionBloc.state.id + 1])
          ],
          child: SectionWidget(
            bounds: Bounds(top: false, left: false, right: false),
          ),
        ),
      );
    }
    return list;
  }

  List<Widget> createChapterBackgrounds(List<SectionBloc> sectionBlocs) {
    return sectionBlocs
        .where((sectionBloc) => sectionBloc.state.id >= 0)
        .map(
          (sectionBloc) => BlocProvider(
            create: (_) => sectionBloc,
            child: SectionBackgroundWidget(),
          ),
        )
        .toList();
  }

  _ready(BuildContext context, List<SectionBloc> sectionBlocs,
      List<NotesBloc> notesBlocs) {
    return Listener(
      onPointerSignal: (signal) {
        if (signal is PointerScrollEvent) {
          offset += signal.scrollDelta.dy;
          context.read<BookBloc>().add(UpdateBookOffsetEvent(offset));
        }
      },
      child: Scaffold(
        body: Stack(children: [
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
              children: createChapterBackgrounds(sectionBlocs),
            ),
          ]),
          Column(children: [
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
            Row(children: [
              ...createChapters(context, sectionBlocs, notesBlocs),
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
            ]),
          ]),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.watch<BooksBloc>(),
      child: BlocBuilder<BooksBloc, BooksState>(builder: (context, state) {
        final books = (state as BooksReadyState).list;
        final book = books.firstWhere((book) => book.id == widget.bookId);
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => BookBloc(book)),
            BlocProvider(create: (_) => SectionsBloc(widget.bookId)),
          ],
          child: BlocBuilder<BookBloc, Book>(builder: (__, _) {
            return BlocBuilder<SectionsBloc, SectionsState>(
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
                  final sections = (state as SectionsReadyState).list ?? [];
                  final sectionBlocs =
                      sections.map((s) => SectionBloc(s)).toList();
                  final notesBlocs =
                      sections.map((s) => NotesBloc(s.bookId, s.id)).toList();
                  return _ready(context, sectionBlocs, notesBlocs);
                  break;
              }
            });
          }),
        );
      }),
    );
  }
}
