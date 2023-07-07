import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/todo.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleDisable()) {
    on<ScheduleSetTimer>(_scheduleSetTimer);
    on<ScheduleCancel>(_scheduleCancer);
  }

  Future<FutureOr<void>> _scheduleSetTimer(
      ScheduleSetTimer event, Emitter<ScheduleState> emit) async {
    final todo = event.todo;
    var scheduledDateTime = DateTime(
      todo.date.year,
      todo.date.month,
      todo.date.day,
      event.time.hour,
      event.time.minute,
    );

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: todo.id!,
        channelKey: 'basic_channel',
        title: 'Todo Today ${Emojis.hand_backhand_index_pointing_down}',
        body: todo.title,
      ),
      schedule: NotificationCalendar.fromDate(
        date: scheduledDateTime,
      ),
    );

    emit(ScheduleEnable());
  }

  Future<FutureOr<void>> _scheduleCancer(
      ScheduleCancel event, Emitter<ScheduleState> emit) async {
    await AwesomeNotifications().cancelSchedule(event.id);
    emit(ScheduleDisable());
  }
}
