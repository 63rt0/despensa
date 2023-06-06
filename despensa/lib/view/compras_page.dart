import 'dart:collection';

import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/ingredientes.dart';
import '../main.dart';

class ComprasPage extends StatefulWidget {
  const ComprasPage({Key? key}) : super(key: key);

  @override
  ComprasPageState createState() => ComprasPageState();
}

class ComprasPageState extends State<ComprasPage> {
  final TextEditingController _textEditingController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
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
        title: const Text('Compras'),
      ),
      body: Column(
        children:[ 
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
                title: Text(
                    _filteredIngredientes.hashMap.values.elementAt(index).nombre),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                IconButton( 
                    icon : const Icon(Icons.shopping_basket),
                    onPressed: () => _moveIngredienteToDespensa(
                      _filteredIngredientes.hashMap.keys.elementAt(index)),
                ),
                  IconButton( 
                    icon : const Icon(Icons.delete),
                    onPressed: () => _removeIngredienteFromCompra(
                      _filteredIngredientes.hashMap.keys.elementAt(index)),
                ),
                ],
              )
            );
            },
                  ),
          ),
        ],),
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
    Ingredientes filteredIngredientes = Data().filteredIngredientesInCompra(searchTerm);
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
                _addIngredienteToCompra(nombreIngrediente);
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

  void _removeIngredienteFromCompra(String key) {
    setState(() {
      Data().updateIngredienteCompra(key, false);
      Data().removeIngredienteFrom(key, _filteredIngredientes);
    });
  }

    void _moveIngredienteToDespensa(String key) {
    setState(() {
      Data().updateIngredienteCompra(key, false);
      Data().updateIngredienteDespensa(key, true);
      _filterIngredientes();
    });
  }

  void _addIngredienteToCompra(String nombreIngrediente) {
    setState(() {
      List<dynamic> ingredienteEntry = Data().addIngrediente(nombreIngrediente);
      Data().updateIngredienteCompra(ingredienteEntry[0], true);
      _filterIngredientes();
    });
  }
}
