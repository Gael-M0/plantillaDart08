import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'TaskListScreen .dart';
import 'Screens/taskMate/models/task_model.dart';

void main() async {
  // Inicialización de Hive
  await Hive.initFlutter();

  // Registrar adaptadores de los modelos
  Hive.registerAdapter(TaskAdapter());

  // Abrir una caja de Hive donde se guardarán las tareas
  await Hive.openBox<Task>('tasks');

  // Correr la aplicación
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TaskListScreen(),
    );
  }
}