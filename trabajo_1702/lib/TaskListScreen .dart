import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'AddTaskScreen .dart';
import 'Screens/taskMate/models/task_model.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Tareas")),
      //Permite escuchar cambios en la caja de tareas y actualizar la UI automáticamente.
      body: ValueListenableBuilder(
        //Se usa Hive.box<Task>('tasks').listenable() para escuchar cambios en la caja de tareas. 
        //Esto significa que cada vez que se agrega, actualiza o elimina una tarea de la caja, el widget se 
        //volverá a construir automáticamente.
        valueListenable: Hive.box<Task>('tasks').listenable(),
        builder: (context, Box<Task> box, _) {
          if (box.isEmpty) return const Center(child: Text("No hay tareas aún."));
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final task = box.getAt(index);
              return Card(
                child: ListTile(
                  leading: task!.imagePath != null ? Image.file(File(task.imagePath!), width: 50) : Icon(Icons.task),
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: task.latitude != null
                      ? const Icon(Icons.location_on, color: Colors.red)
                      : const Icon(Icons.location_off, color: Colors.grey),
                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
