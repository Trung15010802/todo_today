import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/todo/todo_bloc.dart';
import '../widgets/todo_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final DateTime today;
  @override
  void didChangeDependencies() {
    DateTime now = DateTime.now();
    today = DateTime(now.year, now.month, now.day);
    context.read<TodoBloc>().add(TodoGetByDate(dateTime: today));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          flex: 1,
          child: SearchBar(),
        ),
        Expanded(
          flex: 10,
          child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state is TodoLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is TodoError) {
                return const Center(
                  child: Text('An error has occurred'),
                );
              }
              if (state is TodoLoaded) {
                return Column(
                  children: [
                    Expanded(
                      flex: 10,
                      child: TodoList(
                        todos: state.todos,
                        todoListType: state.todoListType,
                        onRefresh: () {
                          context
                              .read<TodoBloc>()
                              .add(TodoRefreshList(dateTime: today));
                        },
                        onFilterAll: () {
                          context.read<TodoBloc>().add(TodoGetAll(date: today));
                        },
                        onFilterComplete: () {
                          context.read<TodoBloc>().add(TodoFilterList(
                              isCompleted: true, dateTime: today));
                        },
                        onFilterUncomplete: () {
                          context.read<TodoBloc>().add(TodoFilterList(
                              isCompleted: false, dateTime: today));
                        },
                      ),
                    ),
                    Visibility(
                      visible: state.todos.isEmpty,
                      child: Expanded(
                        flex: 2,
                        child: Text(
                          "There is no todo here yet!",
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: TextField(
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context
                  .read<TodoBloc>()
                  .add(TodoSearchByTitle(searchTerm: _controller.text));
            },
          ),
        ),
      ),
    );
  }
}
