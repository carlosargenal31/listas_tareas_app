import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lista_tareas_app/clases/task.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final List<Task> tasks = [];
  final _tasksController = StreamController<List<Task>>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Task>>(
      stream: _tasksController.stream,
      initialData: tasks,
      builder: (context, snapshot) {
        final updatedTasks = snapshot.data ?? [];

        return Scaffold(
          appBar: AppBar(
            title: Text('To-Do App'),
          ),
          body: updatedTasks.isEmpty
              ? Center(
                  child: Text('No hay tareas'),
                )
              : ListView.builder(
                  itemCount: updatedTasks.length,
                  itemBuilder: (context, index) {
                    return TaskWidget(
                      task: updatedTasks[index],
                      onToggle: () {
                        _toggleTask(index);
                      },
                      onDelete: () {
                        _deleteTask(index);
                      },
                      onUpdate: () {
                        _updateTask(context, index);
                      },
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _addTask(context);
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _addTask(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nueva tarea'),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Ingrese el título de la tarea',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Ingrese la descripción de la tarea',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tasks.add(Task(
                    title: titleController.text,
                    description: descriptionController.text,
                    completed: false,
                  ));
                });
                _tasksController.add(tasks);
                Navigator.of(context).pop();
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _toggleTask(int index) {
    setState(() {
      tasks[index] = tasks[index].copyWith(completed: !tasks[index].completed);
    });
    _tasksController.add(tasks);
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    _tasksController.add(tasks);
  }

  void _updateTask(BuildContext context, int index) {
    TextEditingController titleController =
        TextEditingController(text: tasks[index].title);
    TextEditingController descriptionController =
        TextEditingController(text: tasks[index].description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Actualizar tarea'),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Ingrese el nuevo título de la tarea',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Ingrese la nueva descripción de la tarea',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tasks[index] = Task(
                    title: titleController.text,
                    description: descriptionController.text,
                    completed: tasks[index].completed,
                  );
                });
                _tasksController.add(tasks);
                Navigator.of(context).pop();
              },
              child: Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tasksController.close();
    super.dispose();
  }
}

class TaskWidget extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const TaskWidget({
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: task.description.isNotEmpty ? Text(task.description) : null,
      leading: Checkbox(
        value: task.completed,
        onChanged: (value) {
          onToggle();
        },
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              onUpdate();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              onDelete();
            },
          ),
        ],
      ),
    );
  }
}
