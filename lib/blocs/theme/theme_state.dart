part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  const ThemeState({
    required this.themeMode,
  });

  @override
  List<Object> get props => [themeMode];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'themeModeIndex': themeMode.index,
    };
  }

  factory ThemeState.fromJson(Map<String, dynamic> map) {
    return ThemeState(
      themeMode: ThemeMode.values[map['themeModeIndex']],
    );
  }
}
