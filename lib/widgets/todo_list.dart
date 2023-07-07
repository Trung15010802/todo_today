import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'todo_item.dart';

import '../blocs/todo/todo_bloc.dart';
import '../model/todo.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final TodoListType todoListType;
  final VoidCallback onRefresh;
  final VoidCallback onFilterAll;
  final VoidCallback onFilterComplete;
  final VoidCallback onFilterUncomplete;

  const TodoList({
    super.key,
    required this.todos,
    required this.todoListType,
    required this.onRefresh,
    required this.onFilterAll,
    required this.onFilterComplete,
    required this.onFilterUncomplete,
  });

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return RefreshIndicator(
      onRefresh: () async => onRefresh,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ChoiceChip(
                label: Text(
                  'All',
                  style: TextStyle(color: colorScheme.onBackground),
                ),
                selected: todoListType == TodoListType.all,
                onSelected: (value) {
                  onFilterAll();
                },
              ),
              ChoiceChip(
                label: Text(
                  'Completed',
                  style: TextStyle(color: colorScheme.onBackground),
                ),
                selected: todoListType == TodoListType.complete,
                onSelected: (value) {
                  onFilterComplete();
                },
              ),
              ChoiceChip(
                label: Text(
                  'Uncompleted',
                  style: TextStyle(color: colorScheme.onBackground),
                ),
                selected: todoListType == TodoListType.uncomplete,
                onSelected: (value) {
                  onFilterUncomplete();
                },
              ),
            ],
          ),
          Visibility(
            visible: todos.isEmpty,
            child: Center(
              child: Lottie.asset('assets/todo.json'),
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return TodoItem(
                  todo: todos[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
