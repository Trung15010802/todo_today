import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/bottom_nav/bottom_nav_bloc.dart';
import '../blocs/todo/todo_bloc.dart';
import '../model/todo.dart';
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
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Stats',
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
              child: const AddNewTodoForm(),
            ),
          );
        },
        child: const Icon(Icons.add_task),
      ),
    );
  }
}

class AddNewTodoForm extends StatefulWidget {
  const AddNewTodoForm({
    super.key,
  });

  @override
  State<AddNewTodoForm> createState() => _AddNewTodoFormState();
}

class _AddNewTodoFormState extends State<AddNewTodoForm> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  String? description;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            children: [
              const Text(
                'Add new todo',
                style: TextStyle(fontSize: 24),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: const TextStyle(fontSize: 24),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    hintText: 'Input title',
                    label: const Text(
                      'Title',
                      style: TextStyle(fontSize: 24),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Title cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (newValue) => title = newValue!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 3,
                  style: const TextStyle(fontSize: 24),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    hintText: 'Input description',
                    label: const Text(
                      'Description',
                      style: TextStyle(fontSize: 24),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onSaved: (newValue) => description = newValue,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final todo = Todo(
                            title: title,
                            description: description,
                            date: DateTime.now());
                        context
                            .read<TodoBloc>()
                            .add(TodoAddButtonPressed(todo: todo));

                        FocusScope.of(context).unfocus();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
