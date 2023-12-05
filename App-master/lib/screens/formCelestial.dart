import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planets/database/database_helper.dart';
import 'dart:io';
import 'dart:async';
import 'package:planets/screens/formSistem.dart';
import 'package:sqflite/sqflite.dart';

class CREATE_CELE_BODY {
  Future<List<INFO_SISTEM>> databasehelpetinfosistem() async {
    Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('sistemas');
    return List.generate(maps.length, (i) {
      return INFO_SISTEM.fromMap(maps[i]);
    });
  }

  final int? id;
  final String nombre;
  final String foto;
  final String descripcion;
  final String tipo;
  final String naturaleza;
  final double tamano;
  final double distancia;
  final int? sistemaId;

  Future<List<CREATE_CELE_BODY>> databasehelpercelebody() async {
    Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('cuerpos_celestes');
    return List.generate(maps.length, (i) {
      return CREATE_CELE_BODY.fromMap(maps[i]);
    });
  }

  CREATE_CELE_BODY({
    this.id,
    required this.nombre,
    required this.foto,
    required this.descripcion,
    required this.tipo,
    required this.naturaleza,
    required this.tamano,
    required this.distancia,
    this.sistemaId,
  });

  Future<INFO_SISTEM> databasehelperinfoinsis(int id) async {
    Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sistemas',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return INFO_SISTEM.fromMap(maps.first);
    } else {
      throw Exception('Sistema no encontrado');
    }
  }

  factory CREATE_CELE_BODY.fromMap(Map<String, dynamic> map) {
    return CREATE_CELE_BODY(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      foto: map['foto'] as String,
      descripcion: map['descripcion'] as String,
      tipo: map['tipo'] as String,
      naturaleza: map['naturaleza'] as String,
      tamano: map['tamano'] as double,
      distancia: map['distancia'] as double,
      sistemaId: map['sistemaId'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'foto': foto,
      'descripcion': descripcion,
      'tipo': tipo,
      'naturaleza': naturaleza,
      'tamano': tamano,
      'distancia': distancia,
      'sistemaId': sistemaId,
    };
  }
}

class AddCREATE_CELE_BODYScreen extends StatefulWidget {
  @override
  _AddCREATE_CELE_BODYScreenState createState() =>
      _AddCREATE_CELE_BODYScreenState();
}

class _AddCREATE_CELE_BODYScreenState extends State<AddCREATE_CELE_BODYScreen> {
  final _formKey = GlobalKey<FormState>();
  String CC_N = '';
  File? CC_F;
  String CC_D = '';
  String CC_T = 'Star';
  String CC_NA = 'Gas';
  double CC_TA = 0.0;
  double CC_DI = 0.0;
  int? CC_SI;
  List<INFO_SISTEM> CC_SS = [];

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _cargarSistemas();
  }

  Future<void> _cargarSistemas() async {
    List<INFO_SISTEM> sistemasRecuperados =
        await DatabaseHelper.instance.GET_SS_CSR();
    setState(() {
      CC_SS = sistemasRecuperados;
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        CC_F = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        CC_F = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Celestial Body'),
        backgroundColor: Color.fromARGB(255, 188, 54, 172),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/images/5.png'), // Ruta de tu imagen de fondo
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(26.0),
            children: <Widget>[
              if (CC_F != null) Image.file(CC_F!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: getImageFromCamera,
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 188, 54, 172),
                    ),
                    child: Text('Take photo'),
                  ),
                  ElevatedButton(
                    onPressed: getImageFromGallery,
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 188, 54, 172),
                    ),
                    child: Text('Select from gallery'),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => CC_N = value!,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => CC_D = value!,
              ),
              DropdownButtonFormField<String>(
                value: CC_T,
                items: <String>[
                  'Star',
                  'Planet',
                  'Asteroid',
                  'Kite',
                  'Unidentified'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    CC_T = newValue!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: CC_NA,
                items: <String>['Gas', 'Liquid', 'Solid', 'Rocky']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    CC_NA = newValue!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Size'),
                onSaved: (value) => CC_TA = double.parse(value!),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Distance from Earth'),
                onSaved: (value) => CC_DI = double.parse(value!),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<int?>(
                value: CC_SI,
                items: CC_SS.map<DropdownMenuItem<int?>>((INFO_SISTEM sistema) {
                  return DropdownMenuItem<int?>(
                    value: sistema.id,
                    child: Text(sistema.nombre),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    CC_SI = newValue;
                  });
                },
                decoration:
                    InputDecoration(labelText: 'Choose System that comes from'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            CREATE_CELE_BODY nuevoCREATE_CELE_BODY = CREATE_CELE_BODY(
              nombre: CC_N,
              foto: CC_F?.path ?? '',
              descripcion: CC_D,
              tipo: CC_T,
              naturaleza: CC_NA,
              tamano: CC_TA,
              distancia: CC_DI,
              sistemaId: CC_SI,
            );

            await DatabaseHelper.instance.CREATE_CEL(nuevoCREATE_CELE_BODY);

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Celestial Body successfully saved')));

            Navigator.of(context).pop(true);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Color.fromARGB(255, 188, 54, 172),
      ),
    );
  }
}
