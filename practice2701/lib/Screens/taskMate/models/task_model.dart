import 'package:hive/hive.dart';

part 'task_model.g.dart'; // Archivo que se generará automáticamente

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String? imagePath;

  @HiveField(3)
  double? latitude;

  @HiveField(4)
  double? longitude;

  Task({
    required this.title,
    required this.description,
    this.imagePath,
    this.latitude,
    this.longitude,
  });
}
