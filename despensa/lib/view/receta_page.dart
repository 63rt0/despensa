import 'dart:collection';

import 'package:flutter/material.dart';
import '../data/data.dart';
import '../data/ingrediente.dart';
import '../data/ingredientes.dart';
import '../data/receta.dart';
import '../main.dart';

class RecetaPage extends StatefulWidget {
  Receta receta;
  RecetaPage({super.key, required this.receta});

  @override
  RecetaPageState createState() => RecetaPageState();
}

class RecetaPageState extends State<RecetaPage> {
  final TextEditingController _textEditingController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  Ingredientes _filteredIngredientes = Ingredientes(HashMap());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receta.nombre),
      ),
      drawer: const DrawerNavigation(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: widget.receta.idIngredientes.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final ingrediente = Data().getIngrediente(
                    widget.receta.idIngredientes.elementAt(index));
                return ListTile(
                    title: Text(ingrediente.nombre),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!ingrediente.despensa)
                          IconButton(
                            icon: const Icon(Icons.add_home),
                            onPressed: () =>
                                _addIngredienteToDespensa(ingrediente.nombre),
                          ),
                        if (!ingrediente.compra)
                          IconButton(
                            icon: const Icon(Icons.add_shopping_cart),
                            onPressed: () =>
                                _addIngredienteToCompra(ingrediente.nombre),
                          ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () =>
                              _removeIngrediente(ingrediente.nombre),
                        ),
                      ],
                    ));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createIngrediente,
        tooltip: 'Añadir',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }

  void _createIngrediente() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir ingrediente'),
          content: TextField(
            controller: _textEditingController,
            decoration:
                const InputDecoration(hintText: 'Escribe el ingrediente'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String nombreIngrediente = _textEditingController.text;
                _addIngrediente(nombreIngrediente);
                _textEditingController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }

  void _removeIngrediente(String nombreIngrediente) {
    setState(() {
      widget.receta=Data().removeIngredienteFromReceta(nombreIngrediente, widget.receta);
    });
  }

  void _addIngredienteToCompra(String key) {
    setState(() {
      Data().updateIngredienteCompra(key, true);
    });
  }

  void _addIngredienteToDespensa(String key) {
    setState(() {
      Data().updateIngredienteDespensa(key, true);
    });
  }

  void _addIngrediente(String nombreIngrediente) {
    setState(() {
      widget.receta =
          Data().addIngredienteToReceta(nombreIngrediente, widget.receta);
    });
  }
}
