part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class ScheduleSetTimer extends ScheduleEvent {
  final Todo todo;
  final TimeOfDay time;
  const ScheduleSetTimer({
    required this.todo,
    required this.time,
  });
}

class ScheduleCancel extends ScheduleEvent {
  final int id;
  const ScheduleCancel({
    required this.id,
  });
}
