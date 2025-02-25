import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'Screens/taskMate/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _image;
  double? _latitude;
  double? _longitude;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

  void _saveTask() {
    final newTask = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      imagePath: _image?.path,
      latitude: _latitude,
      longitude: _longitude,
    );

    final taskBox = Hive.box<Task>('tasks');
    taskBox.add(newTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nueva Tarea")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Título')),
            TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Descripción')),
            const SizedBox(height: 10),
            _image != null
                ? Image.file(_image!, height: 100)
                : ElevatedButton.icon(onPressed: _pickImage, icon: const Icon(Icons.camera), label: const Text("Tomar Foto")),
            const SizedBox(height: 10),
            _latitude == null
                ? ElevatedButton.icon(onPressed: _getLocation, icon: const Icon(Icons.location_on), label: const Text("Obtener Ubicación"))
                : Text("Ubicación: $_latitude, $_longitude"),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _saveTask, child: const Text("Guardar Tarea"))
          ],
        ),
      ),
    );
  }
}
