import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planets/database/database_helper.dart';
import 'dart:io';

import 'package:sqflite/sqflite.dart';

class INFO_SISTEM {
  Future<int> inseinfosistem(INFO_SISTEM sistema) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.insert('sistemas', sistema.toMap());
  }

  final int? id;
  final String nombre;
  final String foto;
  final String descripcion;
  final double tamano;
  final double distancia;

  Future<List<INFO_SISTEM>> modifiinfogenerate() async {
    Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('sistemas');
    return List.generate(maps.length, (i) {
      return INFO_SISTEM.fromMap(maps[i]);
    });
  }

  INFO_SISTEM({
    this.id,
    required this.nombre,
    required this.foto,
    required this.descripcion,
    required this.tamano,
    required this.distancia,
  });
  factory INFO_SISTEM.fromMap(Map<String, dynamic> map) {
    return INFO_SISTEM(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      foto: map['foto'] as String,
      descripcion: map['descripcion'] as String,
      tamano: map['tamano'] as double,
      distancia: map['distancia'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'foto': foto,
      'descripcion': descripcion,
      'tamano': tamano,
      'distancia': distancia,
    };
  }
}

class AddSistemaScreen extends StatefulWidget {
  @override
  _AddSistemaScreenState createState() => _AddSistemaScreenState();
}

class _AddSistemaScreenState extends State<AddSistemaScreen> {
  final _formKey = GlobalKey<FormState>();
  String S_N = '';
  File? S_F;
  String S_D = '';
  double S_T = 0.0;
  double S_DI = 0.0;

  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        S_F = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add System'),
        backgroundColor: Color.fromARGB(255, 188, 54, 172),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/5.png', // Asegúrate de tener la ruta correcta
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  if (S_F != null) Image.file(S_F!),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => getImage(ImageSource.camera),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 188, 54, 172),
                        ),
                        child: Text('Take photo'),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => getImage(ImageSource.gallery),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 188, 54, 172),
                        ),
                        child: Text('From gallery'),
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    onSaved: (value) => S_N = value!,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
                    onSaved: (value) => S_D = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Size in km'),
                    onSaved: (value) => S_T = double.parse(value!),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Distance from Earth'),
                    onSaved: (value) => S_DI = double.parse(value!),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            INFO_SISTEM nuevoSistema = INFO_SISTEM(
              nombre: S_N,
              foto: S_F?.path ?? '',
              descripcion: S_D,
              tamano: S_T,
              distancia: S_DI,
            );

            await DatabaseHelper.instance.CREATE_SIS(nuevoSistema);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('System saved successfully')),
            );

            Navigator.of(context).pop(true);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Color.fromARGB(255, 188, 54, 172),
      ),
    );
  }
}
