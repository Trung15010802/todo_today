import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_today/model/todo.dart';

import '../blocs/schedule/schedule_bloc.dart';
import '../blocs/todo/todo_bloc.dart';
import '../widgets/todo_form.dart';

class TodoDetailScreen extends StatelessWidget {
  const TodoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoading) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is TodoDetailTodo) {
          return WillPopScope(
            onWillPop: () async {
              context.read<TodoBloc>().add(
                    TodoGetByDate(dateTime: state.todo.date),
                  );
              return true;
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                title: const Text('Todo'),
                centerTitle: false,
                elevation: 4,
                actions: [
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: TodoForm(
                            todo: state.todo,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Edit todo',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
              body: Builder(
                builder: (context) {
                  return SingleChildScrollView(
                    child: ListTile(
                      tileColor: Theme.of(context).colorScheme.surface,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      title: SelectableText(
                        state.todo.title,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                      subtitle: SelectableText(
                        state.todo.description ?? '',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ),
                  );
                },
              ),
              floatingActionButton: ScheduleWidget(
                todo: state.todo,
              ),
            ),
          );
        }

        return Container();
      },
    );
  }
}

class ScheduleWidget extends StatefulWidget {
  final Todo todo;
  const ScheduleWidget({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);

        bool hasSchedule = state is! ScheduleDisable;

        return Visibility(
          visible: widget.todo.date.isAtSameMomentAs(today),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  var time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (time != null && context.mounted) {
                    context.read<ScheduleBloc>().add(
                          ScheduleSetTimer(
                            todo: widget.todo,
                            time: time,
                          ),
                        );

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Set up reminder successfully!')));
                  }
                },
                child: const Icon(Icons.schedule),
              ),
              const SizedBox(
                width: 10,
              ),
              Visibility(
                visible: hasSchedule,
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    context
                        .read<ScheduleBloc>()
                        .add(ScheduleCancel(id: widget.todo.id!));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Canncel reminder successfully!')));
                  },
                  child: const Icon(Icons.cancel_schedule_send),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
