import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_keeper/bloc/search/search_event.dart';
import 'package:notes_keeper/bloc/search/search_state.dart';
import '../../models/note.dart';
import '../../repository/notes_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final NotesRepository _notesRepository = NotesRepository();
  SearchBloc() : super(SearchInitialState()) {
    on<SearchGetAllNotesEvent>((event, emit) async {
      emit.call(SearchLoadingListState());
      try {
        List<Note> notes = await _notesRepository.getAllNotes();
        emit.call(SearchLoadedListState(notes));
      } catch (e) {
        emit.call(SearchErrorState(e.toString()));
      }
    });

    on<SearchGetNotesWithTextEvent>((event, emit) {
      List<Note> notesList = event.notesList;
      List<Note> filteredList = [];
      filteredList = notesList
          .where((note) =>
              note.title!.toLowerCase().contains(event.text.toLowerCase()))
          .toList();
      if (event.text.isEmpty) {
        emit.call(SearchGetNotesWithTextState(notesList));
      } else {
        emit.call(SearchGetNotesWithTextState(filteredList));
      }
    });
  }
}
