import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/todo_list.dart';

import '../blocs/todo/todo_bloc.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime? date;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () async {
              date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(
                  DateTime.now().year + 1,
                ),
                helpText: 'Select your history todo date!',
              );

              if (context.mounted && date != null) {
                context.read<TodoBloc>().add(TodoGetByDate(dateTime: date!));
              }
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.date_range),
                SizedBox(
                  width: 5,
                ),
                Text('Choose Date'),
              ],
            ),
          ),
        ),
        BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state is TodoLoaded && date != null) {
              return Expanded(
                child: TodoList(
                  todos: state.todos,
                  todoListType: state.todoListType,
                  onRefresh: () {
                    context
                        .read<TodoBloc>()
                        .add(TodoRefreshList(dateTime: date!));
                  },
                  onFilterAll: () {
                    context.read<TodoBloc>().add(TodoGetAll(date: date!));
                  },
                  onFilterComplete: () {
                    context.read<TodoBloc>().add(
                        TodoFilterList(isCompleted: true, dateTime: date!));
                  },
                  onFilterUncomplete: () {
                    context.read<TodoBloc>().add(
                        TodoFilterList(isCompleted: false, dateTime: date!));
                  },
                ),
              );
            }
            return Image.asset('assets/empty.png');
          },
        )
      ],
    );
  }
}
