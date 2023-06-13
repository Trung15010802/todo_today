import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_today/blocs/todo_list/todo_bloc.dart';

import '../model/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          bool isCompleted = false;
          if (state is TodoLoaded) {
            final loadedTodos = state.todos;
            final todoIndex = loadedTodos.indexWhere((t) => t.id == todo.id);
            if (todoIndex != -1) {
              isCompleted = loadedTodos[todoIndex].isCompleted;
            }
          }
          return Checkbox(
            value: isCompleted,
            onChanged: (value) {
              context.read<TodoBloc>().add(
                    TodoToggleStatus(todo.copyWith(isCompleted: value)),
                  );
            },
          );
        },
      ),
      title: Text('${todo.id} ${todo.title}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {},
      ),
    );
  }
}
