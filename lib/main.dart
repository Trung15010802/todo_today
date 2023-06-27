import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'blocs/todo/todo_bloc.dart';
import 'data/todo_repository.dart';
import 'themes/color_schemes.g.dart';

import 'blocs/bottom_nav/bottom_nav_bloc.dart';
import 'screens/tab_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TodoRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => BottomNavBloc(),
          ),
          RepositoryProvider(
            create: (context) => TodoRepository(),
          ),
          BlocProvider(
            create: (context) => TodoBloc(
              todoRepository: context.read<TodoRepository>(),
            )..add(
                TodoGetAll(
                    date: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                )),
              ),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
            textTheme: GoogleFonts.aBeeZeeTextTheme(),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
            textTheme: GoogleFonts.aBeeZeeTextTheme(),
          ),
          home: const TabScreen(),
        ),
      ),
    );
  }
}
