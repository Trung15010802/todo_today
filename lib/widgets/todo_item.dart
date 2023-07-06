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
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(todo.id),
      onDismissed: (_) {
        context.read<TodoBloc>().add(
              TodoDelete(todo: todo),
            );
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todo was deleted!'),
          ),
        );
      },
      background: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Expanded(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: Colors.red,
            ),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
      child: Container(
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
      ),
    );
  }
}
