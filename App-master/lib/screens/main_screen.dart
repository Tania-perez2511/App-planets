import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';
import 'package:planets/database/database_helper.dart';
import 'package:planets/screens/formCelestial.dart';
import 'package:planets/screens/formSistem.dart';
import 'package:planets/screens/CelestialD.dart';
import 'package:planets/screens/SistemD.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget Planets_Filt() {
    List<Map<String, String>> tiposConImagenes = [
      {'tipo': 'All', 'imagen': 'starr.png'},
      {'tipo': 'Star', 'imagen': 'st.png'},
      {'tipo': 'Planet', 'imagen': 'jup.png'},
      {'tipo': 'Asteroid', 'imagen': 'venu.png'},
      {'tipo': 'Kite', 'imagen': 'aster.png'},
      {'tipo': 'Unidentified', 'imagen': 'nept.png'},
    ];

    return Container(
      height: 120,
      margin: EdgeInsets.only(top: 14),
      padding: EdgeInsets.symmetric(horizontal: 1),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tiposConImagenes.length,
        itemBuilder: (context, index) {
          String tipo = tiposConImagenes[index]['tipo']!;
          String imagen = tiposConImagenes[index]['imagen']!;
          String imagenPath = 'assets/images/$imagen';

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(imagenPath),
                ),
                SizedBox(height: 3),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _Change_Type_FIl = tipo;
                      _Change_Type();
                    });
                  },
                  child: Text(
                    tipo,
                    style: TextStyle(
                      color:
                          _Change_Type_FIl == tipo ? Colors.blue : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<INFO_SISTEM> _sistemas = [];
  List<CREATE_CELE_BODY> _cuerposCelestes = [];
  List<CREATE_CELE_BODY> _cuerposFiltrados = [];
  String _Change_Type_FIl = 'All';

  @override
  void initState() {
    super.initState();
    Change_State();
  }

  Future<void> Change_State() async {
    _sistemas = await DatabaseHelper.instance.GET_SS_CSR();
    _cuerposCelestes = await DatabaseHelper.instance.GET_CEL_TYPE();
    _Change_Type();
  }

  void _Change_Type() {
    setState(() {
      if (_Change_Type_FIl == 'All') {
        _cuerposFiltrados = _cuerposCelestes;
      } else {
        _cuerposFiltrados = _cuerposCelestes
            .where((cuerpo) => cuerpo.tipo == _Change_Type_FIl)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Planets',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            height: 0,
            fontSize: 38,
          ),
        ),
        backgroundColor: Color.fromARGB(0, 241, 223, 207),
        elevation: 0,
        actions: <Widget>[
          Container(
            decoration: BoxDecoration(),
            child: IconButton(
              icon: Image.asset(
                'assets/images/jupi.png',
                height: 84,
                width: 84,
              ),
              onPressed: () async {
                final resultado = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddSistemaScreen()),
                );

                if (resultado == true) {
                  Change_State();
                }
              },
            ),
          ),
          SizedBox(width: 2),
          Container(
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(),
            child: IconButton(
              icon: Icon(Icons.search, color: Color.fromARGB(255, 0, 0, 0)),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(height: 342.0, autoPlay: false),
              items: _sistemas.map((sistema) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              SistemaDescripcionScreen(sistema: sistema),
                        ));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 247, 185, 2),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.file(
                            File(sistema.foto),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Planets_Filt(),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _cuerposFiltrados.map((cuerpo) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CuerpoCelesteDescripcionScreen(
                              cuerpoCeleste: cuerpo),
                        ));
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                        child: Column(
                          children: <Widget>[
                            ClipOval(
                              child: Container(
                                width: 120,
                                height: 120,
                                child: Image.file(
                                  File(cuerpo.foto),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              cuerpo.nombre,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () async {
          final resultado = await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AddCREATE_CELE_BODYScreen()),
          );

          if (resultado == true) {
            Change_State();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/ros.png',
              height: 96,
              width: 96,
            ),
            Text(
              'Add',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
