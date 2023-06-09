import 'package:flutter/material.dart';
import '../data/data.dart';
import '../main.dart';
import 'receta_page.dart';

class RecetasPage extends StatefulWidget {
  const RecetasPage({Key? key}) : super(key: key);

  @override
  RecetasPageState createState() => RecetasPageState();
}

class RecetasPageState extends State<RecetasPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetas'),
      ),
      drawer: const DrawerNavigation(),
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
                    icon: const Icon(Icons.close),
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
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: 'Nombre de la receta'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String nombreReceta = _textEditingController.text;
                _addReceta(nombreReceta);
                _textEditingController.clear();
                Navigator.of(context).pop();
                _editReceta(Data().recetas.length-1);
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }

  void _editReceta(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RecetaPage(receta: Data().recetas.elementAt(index)),
      ),
    );
  }

  void _removeReceta(int index) {
    setState(() {
      Data().removeReceta(index);
    });
  }

  void _addReceta(String nombreReceta) {
    setState(() {
      Data().addReceta(nombreReceta);
    });
  }
}
