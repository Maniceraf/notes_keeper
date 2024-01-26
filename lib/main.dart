import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_keeper/bloc/notes/notes_bloc.dart';
import 'package:notes_keeper/bloc/notes/notes_event.dart';
import 'package:notes_keeper/bloc/search/search_bloc.dart';
import 'package:notes_keeper/bloc/search/search_event.dart';
import 'package:notes_keeper/screens/home_screen.dart';
import 'package:notes_keeper/utils/theme_constants.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NotesBloc>(
          create: (context) => NotesBloc()..add(GetAllNotesEvent()),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc()..add(SearchGetAllNotesEvent()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes Keeper',
      theme: notesTheme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
