import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/todo/todo_bloc.dart';
import '../model/todo.dart';

class TodoForm extends StatefulWidget {
  final Todo? todo;
  const TodoForm({
    Key? key,
    this.todo,
  }) : super(key: key);

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  String? description;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            children: [
              Text(
                'Add new todo',
                style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    hintText: 'Input title',
                    label: const Text(
                      'Title',
                      style: TextStyle(fontSize: 24),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Title cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (newValue) => title = newValue!,
                  initialValue: widget.todo?.title ?? '',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    hintText: 'Input description',
                    label: const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onSaved: (newValue) => description = newValue,
                  initialValue: widget.todo?.description ?? '',
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      DateTime now = DateTime.now();
                      DateTime today = DateTime(now.year, now.month, now.day);
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final Todo newTodo;
                        if (widget.todo != null) {
                          newTodo = widget.todo!.copyWith(
                            title: title,
                            description: description,
                          );
                        } else {
                          newTodo = Todo(
                            title: title,
                            description: description,
                            date: today,
                          );
                        }
                        context.read<TodoBloc>().add(
                              TodoAddButtonPressed(todo: newTodo),
                            );

                        FocusScope.of(context).unfocus();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
