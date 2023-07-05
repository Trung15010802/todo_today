import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> with HydratedMixin {
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.system)) {
    on<ThemeChanged>((event, emit) {
      emit(
        ThemeState(themeMode: event.themeMode),
      );
    });
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    final themeState = ThemeState.fromJson(json);

    return themeState;
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    final stateJson = state.toJson();

    return stateJson;
  }
}
