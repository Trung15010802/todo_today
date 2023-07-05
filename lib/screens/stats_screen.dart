import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_today/blocs/stats/stats_bloc.dart';
import 'package:todo_today/data/todo_repository.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatsBloc(context.read<TodoRepository>())
        ..add(
          StatsFetch(),
        ),
      child: BlocBuilder<StatsBloc, StatsState>(
        builder: (context, state) {
          if (state is StatsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is StatsLoaded) {
            int totalTodo =
                state.stats['completed'] + state.stats['unCompleted'];
            int countTodoCompleted = state.stats['completed'];
            int totalTodoToday =
                state.stats['completedToday'] + state.stats['unCompletedToday'];
            int countTodoCompletedToday = state.stats['completedToday'];

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Today completion percentage',
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
                PieChartTodo(
                  countTodoCompleted: countTodoCompletedToday,
                  totalTodo: totalTodoToday,
                ),
                Text(
                  'All-time completion percentage',
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
                PieChartTodo(
                  countTodoCompleted: countTodoCompleted,
                  totalTodo: totalTodo,
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}

class PieChartTodo extends StatelessWidget {
  const PieChartTodo({
    super.key,
    required this.countTodoCompleted,
    required this.totalTodo,
  });

  final int countTodoCompleted;
  final int totalTodo;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 100.0,
      lineWidth: 10.0,
      percent: countTodoCompleted != 0 ? countTodoCompleted / totalTodo : 0,
      center: Text(
        countTodoCompleted == 0
            ? '0'
            : '${(countTodoCompleted / totalTodo * 100).round()}%',
        style: TextStyle(
          fontSize: 50,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      progressColor: Theme.of(context).colorScheme.surfaceTint,
    );
  }
}
