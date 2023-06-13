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
      leading: Checkbox(
        value: todo.isCompleted,
        onChanged: (value) {
          context.read<TodoBloc>().add(
                TodoToggleStatus(todo.copyWith(isCompleted: value)),
              );
        },
      ),
      title: Text(
        '${todo.id} ${todo.title}',
        style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {},
      ),
    );
  }
}
