// ignore_for_file: public_member_api_docs, sort_constructors_first
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

class TodoGetAll extends TodoEvent {
  final DateTime date;
  const TodoGetAll({
    required this.date,
  });
}

class TodoUpdate extends TodoEvent {
  final Todo newTodo;

  const TodoUpdate(this.newTodo);
}

class TodoDelete extends TodoEvent {
  final Todo todo;
  const TodoDelete({
    required this.todo,
  });
}

class TodoSearchByTitle extends TodoEvent {
  final String searchTerm;
  const TodoSearchByTitle({
    required this.searchTerm,
  });

  @override
  List<Object> get props => [searchTerm];
}

class TodoRefreshList extends TodoEvent {
  final DateTime dateTime;
  const TodoRefreshList({
    required this.dateTime,
  });
}

class TodoFilterList extends TodoEvent {
  final DateTime dateTime;
  final bool isCompleted;
  const TodoFilterList({
    required this.dateTime,
    required this.isCompleted,
  });
}

class TodoGetByDate extends TodoEvent {
  final DateTime dateTime;

  TodoGetByDate({
    DateTime? dateTime,
  }) : dateTime = dateTime ??
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            );
}

class TodoDisplayDetail extends TodoEvent {
  final Todo todo;
  const TodoDisplayDetail({
    required this.todo,
  });
}
