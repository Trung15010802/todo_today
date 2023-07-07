import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_today/blocs/schedule/schedule_bloc.dart';

import '../blocs/todo/todo_bloc.dart';
import '../main.dart';
import '../screens/todo_detail_screen.dart';

class NotificationHelper {
  static Future<void> notificationInit() async {
    await AwesomeNotifications().initialize(
      'resource://mipmap/launcher_icon',
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          importance: NotificationImportance.High,
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
      debug: false,
    );

    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod);
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    MyApp.navigatorKey.currentContext!.read<TodoBloc>().add(
          TodoDisplayDetail(id: receivedAction.id!),
        );
    MyApp.navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => const TodoDetailScreen(),
      ),
    );
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    Future.delayed(const Duration(seconds: 5));
    MyApp.navigatorKey.currentContext!
        .read<ScheduleBloc>()
        .add(ScheduleCancel(id: receivedNotification.id!));
  }
}
