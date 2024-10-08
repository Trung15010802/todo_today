import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'history_screen.dart';
import '../blocs/bottom_nav/bottom_nav_bloc.dart';
import '../widgets/todo_form.dart';
import 'setting_screen.dart';
import 'stats_screen.dart';

import 'home_screen.dart';

class TabScreen extends StatelessWidget {
  const TabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Todo Today',
          style: TextStyle(color: colorScheme.onPrimary),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.help,
              color: colorScheme.onPrimary,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Tutorial",
                      style: TextStyle(color: colorScheme.onBackground),
                    ),
                    content: Text(
                      "Swipe from right to left to delete a task.\nTap on a todo to view details.",
                      style: TextStyle(color: colorScheme.onBackground),
                    ),
                    actions: [
                      TextButton(
                        child: const Text("Close"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        backgroundColor: colorScheme.primary,
      ),
      bottomNavigationBar: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            fixedColor: colorScheme.primary,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart),
                label: 'Stats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            onTap: (index) => context.read<BottomNavBloc>().add(
                  BottomNavChangeEvent(index: index),
                ),
            currentIndex: state.index,
          );
        },
      ),
      body: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          if (state is BottomNavChangeState) {
            switch (state.index) {
              case 0:
                return const HomeScreen();
              case 1:
                return const StatsScreen();
              case 2:
                return const HistoryScreen();
              case 3:
                return const SettingScreen();
            }
          }
          return const HomeScreen();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const TodoForm(),
            ),
          );
        },
        child: const Icon(Icons.add_task),
      ),
    );
  }
}
