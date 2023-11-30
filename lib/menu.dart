import 'package:flutter/material.dart';
import 'package:viajes/listarViajes.dart';
import 'package:viajes/registroViaje.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 6, 1, 158),
          title: const Text('Areolina - Emanuel'),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.airplane_ticket),
                title: const Text('Registrar Viajes'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistroViajes()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.flight),
                title: const Text('Listar Viajes'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListarViajes()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
