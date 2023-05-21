import 'package:flutter/material.dart';


class IngredientesPage extends StatefulWidget {
  const IngredientesPage({super.key, required this.title});

  final String title;

  @override
  IngredientesPageState createState() => IngredientesPageState();
}

class IngredientesPageState extends State<IngredientesPage> {
  List<String> listaIngredientes = ['Huevos', 'Patatas', 'Leche'];

  final TextEditingController _textEditingController = TextEditingController();

  void _createText() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir ingrediente'),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: 'Escribe el ingrediente'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  String enteredText = _textEditingController.text;
                  listaIngredientes.add(enteredText);
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                onPressed: () => _removeText(index),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createText,
        tooltip: 'Añadir',
        child: const Icon(Icons.add),
      ),
    );
  }
  
  void _removeText(int index) {
    setState(() {
      listaIngredientes.removeAt(index);
    });
  }
}