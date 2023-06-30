import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_today/screens/todo_detail_screen.dart';

import '../blocs/todo/todo_bloc.dart';
import '../model/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.tertiaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        leading: Checkbox(
          shape: const CircleBorder(),
          value: todo.isCompleted,
          onChanged: (value) {
            context.read<TodoBloc>().add(
                  TodoUpdate(todo.copyWith(isCompleted: value)),
                );
          },
        ),
        title: Text(
          ' ${todo.title.toUpperCase()}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
        ),
        trailing: IconButton(
          color: Theme.of(context).colorScheme.error,
          icon: const Icon(Icons.delete),
          onPressed: () {
            context.read<TodoBloc>().add(
                  TodoDelete(todo: todo),
                );
          },
        ),
        onTap: () {
          context.read<TodoBloc>().add(
                TodoDisplayDetail(todo: todo),
              );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const TodoDetailScreen(),
            ),
          );
        },
      ),
    );
  }
}
