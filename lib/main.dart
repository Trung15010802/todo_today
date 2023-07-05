import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_today/blocs/schedule/schedule_bloc.dart';
import 'package:todo_today/blocs/theme/theme_bloc.dart';

import 'package:todo_today/themes/color_schemes.g.dart';
import 'package:todo_today/themes/theme_data.dart';
import 'blocs/todo/todo_bloc.dart';
import 'data/todo_repository.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'blocs/bottom_nav/bottom_nav_bloc.dart';
import 'screens/tab_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  notificationInit(context);
  runApp(const MyApp());
}

Future<void> notificationInit(context) async {
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        importance: NotificationImportance.High,
        defaultColor: lightColorScheme.primary,
        ledColor: Colors.white,
        playSound: true,
        criticalAlerts: true,
        locked: true,
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic group')
    ],
    debug: true,
  );
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({Key? key}) : super(key: key);

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
