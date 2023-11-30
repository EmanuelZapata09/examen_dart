import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ListarViajes extends StatefulWidget {
  const ListarViajes({super.key});

  @override
  State<ListarViajes> createState() => _ListarViajesState();
}

class _ListarViajesState extends State<ListarViajes> {
  final fechaController = TextEditingController(
      text:
          '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}');
  List<dynamic>? preciosDolar;
  List<dynamic> data = [];
  List<dynamic> resultados = [];

  @override
  void initState() {
    super.initState();
    getViajes();
    _consultarPrecioDolar();
  }

  Future<void> _consultarPrecioDolar() async {
    final response = await http.get(
      Uri.parse(
          'https://www.datos.gov.co/resource/32sa-8pi3.json?vigenciadesde=${fechaController.text}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        preciosDolar = json.decode(response.body);
      });
    } else {
      print('Revisar el código, existen fallos ${response.statusCode}');
    }
  }

  Future<void> getViajes() async {
    final response =
        await http.get(Uri.parse('https://api-viaje.onrender.com/api/viaje'));

    //si es 200 es porque todo esta bien
    if (response.statusCode == 200) {
      Map<String, dynamic> decodeData = json.decode(response.body);

      setState(() {
        data = decodeData['viajes'] ?? [];
        print(data);
      });
    } else {
      print('Revisar el código, existen fallos ${response.statusCode}');
    }
  }

  int sumarTotalPasajeros(List<dynamic> viajes) {
    int totalPasajeros = 0;

    for (var viaje in viajes) {
      totalPasajeros += int.parse(viaje['cantidadPasajeros'].toString());
    }

    return totalPasajeros;
  }

  int sumaPrecioPesos(List<dynamic> viajes) {
    int totalPrecios = 0;

    for (var viaje in viajes) {
      totalPrecios += int.parse(viaje['precioPesos'].toString());
    }

    return totalPrecios;
  }

  double sumarValoresEnDolares(List<dynamic> datos) {
    double totalEnDolares = 0.0;

    for (var dato in datos) {
      for (var precio in preciosDolar!) {
        double valorCalculado =
            dato['precioPesos'] / double.parse(precio['valor']);
        totalEnDolares += valorCalculado;
      }
    }

    return totalEnDolares;
  }

  @override
  Widget build(BuildContext context) {
    int totalPasajeros = sumarTotalPasajeros(data);
    int totalPrecios = sumaPrecioPesos(data);
    double totalValoresEnDolares = sumarValoresEnDolares(data);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 1, 158),
        title: const Text('Listar Viajes'),
      ),
      body: Form(
        child: Column(
          children: [
            const Card(
              elevation: 2,
              margin: EdgeInsets.all(50),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('Listar Viajes'),
                ),
              ),
            ),
            Text(
              'Total Pasajeros: $totalPasajeros.',
            ),
            Text('Total Precio COP: $totalPrecios.'),
            Text('Total en Dólares: $totalValoresEnDolares'),
            Expanded(
              child: ListView.builder(
                itemCount:
                    resultados.length > 0 ? resultados.length : data.length,
                itemBuilder: (BuildContext context, int index) {
                  double precioDolares = 0.0;

                  for (var precio in preciosDolar!) {
                    double valorCalculado = data[index]['precioPesos'] /
                        double.parse(precio['valor']);
                    precioDolares += valorCalculado;
                  }

                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Codigo: ${data[index]['codigo']}"),
                          Text("Ciudad Origen: ${data[index]['ciudadOrigen']}"),
                          Text(
                              "Ciudad Destino: ${data[index]['ciudadDestino']}"),
                          Text("Precio Pesos: ${data[index]['precioPesos']}"),
                          Text(
                              "Cantidad Pasajeros: ${data[index]['cantidadPasajeros']}"),
                          Text('Valor en Dólares: $precioDolares'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
