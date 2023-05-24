import 'package:flutter/material.dart';
import 'data.dart';
import 'ingredientes.dart';

class IngredientesPage extends StatefulWidget {
  const IngredientesPage({Key? key}) : super(key: key);

  @override
  IngredientesPageState createState() => IngredientesPageState();
}

class IngredientesPageState extends State<IngredientesPage> {
  final TextEditingController _textEditingController = TextEditingController();

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
                print('Ingredientes: $Data().ingredientes');
                print('HashMap: $Data().ingredientes.hashMap');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredientes'),
      ),
      body: Center(
        child: ListView.separated(
          itemCount: Data().ingredientes.hashMap.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(Data().ingredientes.hashMap.values.elementAt(index)),
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
      String key = Data().ingredientes.hashMap.keys.elementAt(index);
      Data().ingredientes.hashMap.remove(key);
      Data().saveIngredientes();
    });
  }

  void _addIngrediente(String nombreIngrediente) {
    setState(() {
      Ingredientes.addIngrediente(nombreIngrediente);
    });
  }
}
