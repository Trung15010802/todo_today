part of 'todo_bloc.dart';

enum TodoListType {
  complete,
  uncomplete,
  all,
}

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  final TodoListType todoListType;
  const TodoLoaded(this.todos, {this.todoListType = TodoListType.all});
  @override
  List<Object> get props => [todos, todoListType];
}

class TodoDetailTodo extends TodoState {
  final Todo todo;
  const TodoDetailTodo({
    required this.todo,
  });
}

class TodoError extends TodoState {
  final String errorMessage;

  const TodoError(this.errorMessage);
}
