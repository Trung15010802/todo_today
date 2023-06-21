import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/todo/todo_bloc.dart';
import '../widgets/todo_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
                  child: Text('An error has occured'),
                );
              }
              if (state is TodoLoaded) {
                debugPrint(state.todoListType.toString());
                return RefreshIndicator(
                  onRefresh: () async =>
                      context.read<TodoBloc>().add(TodoRefreshList()),
                  child: state.todos.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Cannot find any todo!'),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<TodoBloc>()
                                      .add(TodoRefreshList());
                                },
                                child: const Text('Reload list'),
                              )
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ChoiceChip(
                                  label: const Text('All'),
                                  selected:
                                      state.todoListType == TodoListType.all,
                                  onSelected: (value) {
                                    context.read<TodoBloc>().add(TodoGetAll());
                                  },
                                ),
                                ChoiceChip(
                                  label: const Text('Completed'),
                                  selected: state.todoListType ==
                                      TodoListType.complete,
                                  onSelected: (value) {
                                    context.read<TodoBloc>().add(
                                          const TodoFilterList(
                                              isCompleted: true),
                                        );
                                  },
                                ),
                                ChoiceChip(
                                  label: const Text('Uncompleted'),
                                  selected: state.todoListType ==
                                      TodoListType.uncomplete,
                                  onSelected: (value) {
                                    context.read<TodoBloc>().add(
                                        const TodoFilterList(
                                            isCompleted: false));
                                  },
                                ),
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.todos.length,
                                itemBuilder: (context, index) {
                                  return TodoItem(
                                    todo: state.todos[index],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
    super.key,
  });

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
