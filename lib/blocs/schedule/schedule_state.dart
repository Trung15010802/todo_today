part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleDisable extends ScheduleState {}

class ScheduleDisableSpecificTodo extends ScheduleState {
  final int id;
  const ScheduleDisableSpecificTodo({
    required this.id,
  });
}

class ScheduleEnable extends ScheduleState {}
