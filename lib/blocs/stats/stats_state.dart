// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'stats_bloc.dart';

abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object> get props => [];
}

class StatsLoading extends StatsState {}

class StatsLoaded extends StatsState {
  final Map stats;
  const StatsLoaded({
    required this.stats,
  });
}

class StatsError extends StatsState {}
