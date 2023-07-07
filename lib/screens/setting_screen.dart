import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/theme/theme_bloc.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        bool isDarkMode = state.themeMode == ThemeMode.dark;
        bool isSystemMode = state.themeMode == ThemeMode.system;
        return Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: state.themeMode == ThemeMode.system,
                  onChanged: (value) {
                    context.read<ThemeBloc>().add(ThemeChanged(
                        themeMode:
                            value! ? ThemeMode.system : ThemeMode.light));
                  },
                ),
                Text(
                  'Use system theme mode',
                  style: TextStyle(
                    fontSize: 18,
                    color: colorScheme.onBackground,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sunny),
                Switch(
                  value: isDarkMode,
                  onChanged: isSystemMode
                      ? null
                      : (isDarkMode) {
                          context.read<ThemeBloc>().add(
                                ThemeChanged(
                                  themeMode: isDarkMode
                                      ? ThemeMode.dark
                                      : ThemeMode.light,
                                ),
                              );
                        },
                ),
                const Icon(Icons.dark_mode),
              ],
            ),
          ],
        );
      },
    );
  }
}
