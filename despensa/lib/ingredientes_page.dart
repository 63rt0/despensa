import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IngredientesPage extends StatefulWidget {
  const IngredientesPage({Key? key}) : super(key: key);

  @override
  IngredientesPageState createState() => IngredientesPageState();

  static Future<List<String>> loadIngredientes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('ingredientes') ?? [];
  }

  static Future<void> saveIngredientes(List<String> ingredientes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('ingredientes', ingredientes);
  }
}

class IngredientesPageState extends State<IngredientesPage> {
  List<String> listaIngredientes = [];

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    IngredientesPage.loadIngredientes().then((ingredientes) {
      setState(() {
        listaIngredientes = ingredientes;
      });
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
                setState(() {
                  String enteredText = _textEditingController.text;
                  listaIngredientes.add(enteredText);
                  IngredientesPage.saveIngredientes(listaIngredientes);
                  _textEditingController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredientes'),
      ),
      body: Center(
        child: ListView.separated(
          itemCount: listaIngredientes.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(listaIngredientes[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeIngrediente(index),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createIngrediente,
        tooltip: 'Añadir',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _removeIngrediente(int index) {
    setState(() {
      listaIngredientes.removeAt(index);
      IngredientesPage.saveIngredientes(listaIngredientes);
    });
  }
}
