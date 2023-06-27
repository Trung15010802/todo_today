import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/todo/todo_bloc.dart';

class TodoDetailScreen extends StatelessWidget {
  const TodoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<TodoBloc>().add(TodoGetByDate());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo detail'),
          centerTitle: true,
          elevation: 4,
        ),
        body: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state is TodoDetailTodo) {
              return Builder(
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
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      subtitle: SelectableText(
                        state.todo.description ?? '',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  );
                },
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
