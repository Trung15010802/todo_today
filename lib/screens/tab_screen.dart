import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_today/screens/history_screen.dart';
import '../blocs/bottom_nav/bottom_nav_bloc.dart';
import '../widgets/todo_form.dart';
import 'setting_screen.dart';
import 'stats_screen.dart';

import 'home_screen.dart';

class TabScreen extends StatelessWidget {
  const TabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Todo Today',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      bottomNavigationBar: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            fixedColor: Theme.of(context).colorScheme.primary,
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
