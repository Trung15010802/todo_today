import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/todo_repository.dart';

import '../../model/todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;
  TodoBloc({
    required this.todoRepository,
  }) : super(TodoLoading()) {
    on<TodoAddButtonPressed>(_addTodo);

    on<TodoGetAll>(_getAll);

    on<TodoUpdate>(_todoUpdate);

    on<TodoDelete>(_deleteTodo);

    on<TodoSearchByTitle>(_searchByTitle);

    on<TodoRefreshList>(_refreshList);

    on<TodoFilterList>(_filterList);
  }

  Future<FutureOr<void>> _addTodo(
      TodoAddButtonPressed event, Emitter<TodoState> emit) async {
    await todoRepository.addTodo(event.todo);
    await _reloadList(emit);
  }

  Future<FutureOr<void>> _getAll(
      TodoGetAll event, Emitter<TodoState> emit) async {
    await _reloadList(emit);
  }

  Future<FutureOr<void>> _todoUpdate(
      TodoUpdate event, Emitter<TodoState> emit) async {
    todoRepository.updateTodo(event.newTodo);
    await _reloadList(emit);
  }

  Future<FutureOr<void>> _deleteTodo(
      TodoDelete event, Emitter<TodoState> emit) async {
    await todoRepository.deleteTodo(event.todo);
    await _reloadList(emit);
  }

  Future<FutureOr<void>> _searchByTitle(
      TodoSearchByTitle event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    final todos =
        await todoRepository.searchTodoByTitle(event.searchTerm) ?? [];

    emit(TodoLoaded(todos));
  }

  Future<void> _reloadList(Emitter<TodoState> emit) async {
    final todos = await todoRepository.getAllTodo() ?? [];
    emit(TodoLoaded(todos));
  }

  Future<FutureOr<void>> _refreshList(
      TodoRefreshList event, Emitter<TodoState> emit) async {
    await _reloadList(emit);
  }

  Future<FutureOr<void>> _filterList(
      TodoFilterList event, Emitter<TodoState> emit) async {
    final todos =
        await todoRepository.getTodoByCompletionStatus(event.isCompleted) ?? [];

    emit(
      TodoLoaded(
        todos,
        todoListType:
            event.isCompleted ? TodoListType.complete : TodoListType.uncomplete,
      ),
    );
  }
}
