import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_today/blocs/todo_list/todo_bloc.dart';
import 'package:todo_today/widgets/todo_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<TodoBloc>().add(TodoGetAll());
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        debugPrint('Rebuild');
        if (state is TodoLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is TodoLoaded) {
          var todos = state.todos;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              return BlocProvider<TodoBloc>.value(
                value: context.read<TodoBloc>(),
                child: TodoItem(todo: todos[index]),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
