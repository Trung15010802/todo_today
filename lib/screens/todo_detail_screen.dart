import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/todo/todo_bloc.dart';
import '../widgets/todo_form.dart';

class TodoDetailScreen extends StatelessWidget {
  const TodoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoading) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is TodoDetailTodo) {
          return WillPopScope(
            onWillPop: () async {
              context.read<TodoBloc>().add(
                    TodoGetByDate(dateTime: state.todo.date),
                  );
              return true;
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                title: const Text('Todo '),
                centerTitle: true,
                elevation: 4,
                actions: [
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: TodoForm(
                            todo: state.todo,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Edit todo',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
              body: Builder(
                builder: (context) {
                  return SingleChildScrollView(
                    child: ListTile(
                      tileColor: Theme.of(context).colorScheme.surface,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      title: SelectableText(
                        state.todo.title,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                      subtitle: SelectableText(
                        state.todo.description ?? '',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }

        return Container();
      },
    );
  }
}
