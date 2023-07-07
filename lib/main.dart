import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'blocs/schedule/schedule_bloc.dart';
import 'blocs/theme/theme_bloc.dart';

import 'themes/theme_data.dart';
import 'blocs/todo/todo_bloc.dart';
import 'data/todo_repository.dart';
import 'blocs/bottom_nav/bottom_nav_bloc.dart';
import 'helper/notification_helper.dart';
import 'screens/tab_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  NotificationHelper.notificationInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TodoRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeBloc(),
          ),
          BlocProvider(
            create: (context) => BottomNavBloc(),
          ),
          RepositoryProvider(
            create: (context) => TodoRepository(),
          ),
          BlocProvider(
            create: (context) => TodoBloc(
              todoRepository: context.read<TodoRepository>(),
            )..add(
                TodoGetAll(
                  date: DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                  ),
                ),
              ),
          ),
          BlocProvider(
            create: (context) => ScheduleBloc(),
          )
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              themeMode: state.themeMode,
              theme: appThemeData[AppTheme.light],
              darkTheme: appThemeData[AppTheme.dark],
              home: const TabScreen(),
            );
          },
        ),
      ),
    );
  }
}
