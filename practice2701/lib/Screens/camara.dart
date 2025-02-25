import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraExample extends StatefulWidget {
  const CameraExample({super.key});

  @override
  State<CameraExample> createState() => _CameraExampleState();
}

class _CameraExampleState extends State<CameraExample> {
  List<File> _imageFiles = []; // Lista de imágenes tomadas

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(File(pickedFile.path)); // Agregar imagen a la lista
      });
    } else {
      print("No se seleccionó ninguna imagen.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cámara y Galería'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Tomar Foto'),
          ),
          const Divider(height: 20, thickness: 2),
          Expanded(
            flex: 3,
            child: _imageFiles.isNotEmpty
                ? GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: _imageFiles.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Image.file(_imageFiles[index]),
                              );
                            },
                          );
                        },
                        child: Image.file(
                          _imageFiles[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  )
                : const Center(child: Text('No hay imágenes guardadas.')),
          ),
        ],
      ),
    );
  }
}
