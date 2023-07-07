import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/todo_repository.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final TodoRepository _todoRepository;
  StatsBloc(
    this._todoRepository,
  ) : super(StatsLoading()) {
    on<StatsFetch>(_fetchData);
  }

  Future<FutureOr<void>> _fetchData(
      StatsFetch event, Emitter<StatsState> emit) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    int countTodoByCompletedStatus =
        await _todoRepository.countTodoByCompletedStatus(true);
    int countTodoByUnCompletedStatus =
        await _todoRepository.countTodoByCompletedStatus(false);
    int countTodoByCompletedStatusToday =
        await _todoRepository.countTodoByCompletedStatus(true, dateTime: today);
    int countTodoByUnCompletedStatusToday = await _todoRepository
        .countTodoByCompletedStatus(false, dateTime: today);

    Map stats = {
      'completed': countTodoByCompletedStatus,
      'unCompleted': countTodoByUnCompletedStatus,
      'completedToday': countTodoByCompletedStatusToday,
      'unCompletedToday': countTodoByUnCompletedStatusToday,
    };

    emit(StatsLoaded(stats: stats));
  }
}
