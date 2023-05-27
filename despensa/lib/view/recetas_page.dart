import 'package:flutter/material.dart';
import '../data/data.dart';
import '../main.dart';

class RecetasPage extends StatefulWidget {
  const RecetasPage({Key? key}) : super(key: key);

  @override
  RecetasPageState createState() => RecetasPageState();
}

class RecetasPageState extends State<RecetasPage> {
  final TextEditingController _textEditingControllerIngredientes =
      TextEditingController();
  final TextEditingController _textEditingControllerNombre =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetas'),
      ),
      body: Center(
        child: ListView.separated(
          itemCount: Data().recetas.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(Data().recetas[index].nombre),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editReceta(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeReceta(index),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createRecetaDialog,
        tooltip: 'Añadir',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }

  void _createRecetaDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir receta'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _textEditingControllerNombre,
                  decoration: const InputDecoration(hintText: 'Nombre'),
                ),
                TextField(
                  controller: _textEditingControllerIngredientes,
                  decoration: const InputDecoration(
                      hintText: 'Ingredientes separados por comas'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  String nombreReceta = _textEditingControllerNombre.text;
                  String ingredientesReceta =
                      _textEditingControllerIngredientes.text;
                      _addReceta(nombreReceta, ingredientesReceta);

                  Navigator.of(context).pop();
                });
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }


  void _editReceta(int index) {
    String nombreAntiguo = Data().recetas[index].nombre;
    String ingredientesAntiguo = Data().recetas[index].nombresIngredientes();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar receta'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _textEditingControllerNombre,
                  decoration: InputDecoration(
                    hintText: nombreAntiguo,
                  ),
                ),
                TextField(
                  controller: _textEditingControllerIngredientes,
                  decoration: InputDecoration(
                    hintText: ingredientesAntiguo,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  String nombreReceta =
                      (_textEditingControllerNombre.text == '')
                          ? nombreAntiguo
                          : _textEditingControllerNombre.text;
                  String nombresIngredientes =
                      (_textEditingControllerIngredientes.text == '')
                          ? ingredientesAntiguo
                          : _textEditingControllerIngredientes.text;
                  _removeReceta(index);
                  _addReceta(nombreReceta, nombresIngredientes);
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Modificar'),
            ),
          ],
        );
      },
    );
  }

  void _removeReceta(int index) {
    setState(() {
      Data().recetas.removeAt(index);
      Data().saveRecetas();
    });
  }

    void _addReceta(String nombreReceta, String nombresIngredientes) {
    setState(() {
      Data().addReceta(nombreReceta, nombresIngredientes);
    });
  }
}


