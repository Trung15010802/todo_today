import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_today/blocs/todo_list/todo_bloc.dart';
import 'package:todo_today/data/todo_repository.dart';
import 'package:todo_today/themes/color_schemes.g.dart';

import 'blocs/bottom_nav/bottom_nav_bloc.dart';
import 'screens/tab_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavBloc(),
      child: RepositoryProvider(
        create: (context) => TodoRepository(),
        child: BlocProvider(
          create: (context) => TodoBloc(
            todoRepository: context.read<TodoRepository>(),
          ),
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
            darkTheme:
                ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
            home: const TabScreen(),
          ),
        ),
      ),
    );
  }
}
