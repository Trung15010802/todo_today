// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_today/data/todo_repository.dart';

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

    on<TodoToggleStatus>(_toggleStatus);
  }

  Future<FutureOr<void>> _addTodo(
      TodoAddButtonPressed event, Emitter<TodoState> emit) async {
    await todoRepository.addTodo(event.todo);
    var todos = await todoRepository.getAllTodo();
    emit(TodoLoaded(todos!));
  }

  Future<FutureOr<void>> _getAll(
      TodoGetAll event, Emitter<TodoState> emit) async {
    var todos = await todoRepository.getAllTodo() ?? [];
    emit(TodoLoaded(todos));
  }

  Future<FutureOr<void>> _toggleStatus(
      TodoToggleStatus event, Emitter<TodoState> emit) async {
    await todoRepository.updateTodo(event.newTodo);
    var todos = await todoRepository.getAllTodo();
    emit(TodoLoaded(todos!));
  }
}
