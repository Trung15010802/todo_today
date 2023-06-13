part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class TodoAddButtonPressed extends TodoEvent {
  final Todo todo;
  const TodoAddButtonPressed({
    required this.todo,
  });

  @override
  List<Object> get props => [todo];
}

class TodoGetAll extends TodoEvent {}

class TodoToggleStatus extends TodoEvent {
  final Todo newTodo;

  const TodoToggleStatus(this.newTodo);
}
