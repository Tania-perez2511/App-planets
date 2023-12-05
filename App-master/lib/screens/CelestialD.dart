import 'package:flutter/material.dart';
import 'dart:io';

import 'package:planets/screens/formCelestial.dart';

class CuerpoCelesteDescripcionScreen extends StatelessWidget {
  final CREATE_CELE_BODY cuerpoCeleste;

  CuerpoCelesteDescripcionScreen({required this.cuerpoCeleste});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/2.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(35.0, 60.0, 30.0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                              onTap: () {
                                // Lógica para eliminar el cuerpo celeste
                                // Aquí debes llamar a tu función para borrar el cuerpo celeste
                                // por ejemplo: DatabaseHelper.instance.deleteCuerpoCeleste(cuerpoCeleste.id);
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    width: 270,
                    height: 270,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(122.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.file(
                      File(cuerpoCeleste.foto),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(35.0, 20.0, 30.0, 20),
                  child: Center(
                    child: Text(
                      '${cuerpoCeleste.nombre}',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(35.0, 0.0, 35, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Type: ',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 158, 2),
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: '${cuerpoCeleste.tipo} ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Nature: ',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 158, 2),
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: '${cuerpoCeleste.naturaleza} ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10, 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Size: ',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 158, 2),
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: '${cuerpoCeleste.tamano} ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Distance: ',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 158, 2),
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: '${cuerpoCeleste.distancia} ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {},
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Description',
                            style: TextStyle(
                              color: Color.fromRGBO(245, 184, 2, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'VR Tour',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Map',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 320,
                    padding: EdgeInsets.all(30.0),
                    child: Text('${cuerpoCeleste.descripcion}'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: const Color.fromARGB(255, 105, 105, 105),
                    ),
                    Icon(
                      Icons.location_on_rounded,
                      color: const Color.fromARGB(255, 105, 105, 105),
                    ),
                    Icon(
                      Icons.space_dashboard,
                      color: const Color.fromARGB(255, 105, 105, 105),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
