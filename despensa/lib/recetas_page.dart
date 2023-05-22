import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecetasPage extends StatefulWidget {
  const RecetasPage({Key? key}) : super(key: key);

  @override
  RecetasPageState createState() => RecetasPageState();

  static Future<List<Receta>> loadRecetas() async {
    final prefs = await SharedPreferences.getInstance();
    final recetasData = prefs.getStringList('recetas');

    if (recetasData != null) {
      final recetas = recetasData.map((data) {
        final parts = data.split('|');
        final nombre = parts[0];
        final ingredientes = parts[1].split(',');
        return Receta(nombre, ingredientes);
      }).toList();

      return recetas;
    }

    return [];
  }

  static Future<void> saveRecetas(List<Receta> recetas) async {
    final prefs = await SharedPreferences.getInstance();
    final recetasData = recetas.map((receta) {
      final nombreData = receta.nombre;
      final ingredientesData = receta.listaIngredientes.join(',');
      return '$nombreData|$ingredientesData';
    }).toList();

    await prefs.setStringList('recetas', recetasData);
  }
}

class RecetasPageState extends State<RecetasPage> {
  List<Receta> listaRecetas = [];
  List<String> selectedIngredientes = [];
  final TextEditingController _textEditingControllerIngredientes =
      TextEditingController();
  final TextEditingController _textEditingControllerNombre =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    RecetasPage.loadRecetas().then((recetas) {
      setState(() {
        listaRecetas = recetas;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetas'),
      ),
      body: Center(
        child: ListView.separated(
          itemCount: listaRecetas.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(listaRecetas[index].nombre),
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
        onPressed: _createReceta,
        tooltip: 'Añadir',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createReceta() {
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
                  List<String> listaIngredientesReceta =
                      ingredientesReceta.trim().split(',');
                  listaRecetas
                      .add(Receta(nombreReceta, listaIngredientesReceta));
                  RecetasPage.saveRecetas(listaRecetas);
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
    String nombreAntiguo = listaRecetas[index].nombre;
    String ingredientesAntiguo = listaRecetas[index].ingredientesToString();
    
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
                  String ingredientesReceta =
                      (_textEditingControllerIngredientes.text == '')
                          ? ingredientesAntiguo
                          : _textEditingControllerIngredientes.text;
                  List<String> listaIngredientesReceta =
                      ingredientesReceta.trim().split(',');
                  listaRecetas.removeAt(index);
                  listaRecetas
                      .add(Receta(nombreReceta, listaIngredientesReceta));
                  RecetasPage.saveRecetas(listaRecetas);
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
      listaRecetas.removeAt(index);
      RecetasPage.saveRecetas(listaRecetas);
    });
  }
}

class Receta {
  String nombre;
  List<String> listaIngredientes = [];

  Receta(this.nombre, this.listaIngredientes);


  String ingredientesToString() {

    String ingredientes = listaIngredientes[0];
    for(var i=1; i<listaIngredientes.length;i++){
      ingredientes += ', '+listaIngredientes[i];
    }


    return ingredientes;
  }
}
