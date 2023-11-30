import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistroViajes extends StatefulWidget {
  const RegistroViajes({super.key});

  @override
  State<RegistroViajes> createState() => _RegistroViajesState();
}

class _RegistroViajesState extends State<RegistroViajes> {
  List<String> viajes = [];
  final codigo = TextEditingController();
  final ciudadOrigen = TextEditingController();
  final ciudadDestino = TextEditingController();
  final precioPesos = TextEditingController();
  final cantidadPasajeros = TextEditingController();

  @override
  void initState() {
    super.initState();
    postViajes();
  }

  Future<void> postViajes() async {
    final response = await http.post(
      Uri.parse('https://api-viaje.onrender.com/api/viaje'),
      body: jsonEncode({
        'codigo': codigo.text,
        'ciudadOrigen': ciudadOrigen.text,
        'ciudadDestino': ciudadDestino.text,
        'precioPesos': precioPesos.text,
        'cantidadPasajeros': cantidadPasajeros.text,
      }),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );
    // si es 200 es porque todo esta bien
    if (response.statusCode == 200) {
      setState(() {});
    } else {
      print('Revisar el codigo existen fallos ${response.statusCode}');
    }
  }

  Future<void> LimpiezaForm() async {
    codigo.clear();
    ciudadDestino.clear();
    ciudadOrigen.clear();
    precioPesos.clear();
    cantidadPasajeros.clear();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formViaje = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 1, 158),
        title: const Text('Registrar Viajes'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
        child: Form(
          key: formViaje,
          child: Column(
            children: [
              const Card(
                elevation: 2,
                margin: EdgeInsets.all(50),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Registrar Viaje'),
                  ),
                ),
              ),
              TextFormField(
                  controller: codigo,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text('Codigo'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Este campo es requerido';
                    return null;
                  }),
              TextFormField(
                  controller: ciudadOrigen,
                  decoration:
                      const InputDecoration(label: Text('Ciudad Origen')),
                  validator: (value) {
                    if (value!.isEmpty) return 'Este campo es requerido';
                    return null;
                  }),
              TextFormField(
                  controller: ciudadDestino,
                  decoration:
                      const InputDecoration(label: Text('Ciudad Destino')),
                  validator: (value) {
                    if (value!.isEmpty) return 'Este campo es requerido';
                    return null;
                  }),
              TextFormField(
                  controller: precioPesos,
                  decoration:
                      const InputDecoration(label: Text('Precio Pesos')),
                  validator: (value) {
                    if (value!.isEmpty) return 'Este campo es requerido';
                    return null;
                  }),
              TextFormField(
                  controller: cantidadPasajeros,
                  decoration:
                      const InputDecoration(label: Text('Cantidad Pasajeros')),
                  validator: (value) {
                    if (value!.isEmpty) return 'Este campo es requerido';
                    return null;
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      if (!formViaje.currentState!.validate()) {
                        print('Formulario no valido');
                        return;
                      } else {}
                      postViajes();
                      LimpiezaForm();
                    },
                    child: const Text('Registrar')),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
