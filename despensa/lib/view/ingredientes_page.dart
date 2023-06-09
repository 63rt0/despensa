import 'dart:collection';

import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/ingredientes.dart';
import '../main.dart';

class IngredientesPage extends StatefulWidget {
  const IngredientesPage({Key? key}) : super(key: key);

  @override
  IngredientesPageState createState() => IngredientesPageState();
}

class IngredientesPageState extends State<IngredientesPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  Ingredientes _filteredIngredientes = Ingredientes(HashMap());

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _filterIngredientes();
    });
    _filterIngredientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredientes'),
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
              itemCount: _filteredIngredientes.hashMap.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(_filteredIngredientes.hashMap.values
                        .elementAt(index)
                        .nombre),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!_filteredIngredientes.hashMap.values
                            .elementAt(index)
                            .despensa)
                          IconButton(
                            icon: const Icon(Icons.add_home),
                            onPressed: () => _addIngredienteToDespensa(
                                _filteredIngredientes.hashMap.keys
                                    .elementAt(index)),
                          ),
                          if (!_filteredIngredientes.hashMap.values
                            .elementAt(index)
                            .compra)
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () => _addIngredienteToCompra(
                              _filteredIngredientes.hashMap.keys
                                  .elementAt(index)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => _removeIngrediente(
                              _filteredIngredientes.hashMap.keys
                                  .elementAt(index)),
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

  void _filterIngredientes() {
    String searchTerm = _searchController.text.toLowerCase();
    Ingredientes filteredIngredientes = Data().filteredIngredientes(searchTerm);
    setState(() {
      _filteredIngredientes = filteredIngredientes;
    });
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

  void _removeIngrediente(String key) {
    setState(() {
      Data().removeIngrediente(key);
      Data().removeIngredienteFrom(key, _filteredIngredientes);
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
      Data().addIngrediente(nombreIngrediente);
      _filterIngredientes();
    });
  }
}
