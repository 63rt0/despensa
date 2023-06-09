import 'package:flutter/material.dart';
import '../data/data.dart';
import '../data/receta.dart';
import '../main.dart';

class CocinablesPage extends StatefulWidget {
  const CocinablesPage({Key? key}) : super(key: key);

  @override
  CocinablesPageState createState() => CocinablesPageState();
}

class CocinablesPageState extends State<CocinablesPage> {
  final List<Receta> _recetasCocinables = Data().cocinables();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cocinables'),
      ),
      drawer: const DrawerNavigation(),
      body: Center(
        child: ListView.separated(
          itemCount: _recetasCocinables.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_recetasCocinables[index].nombre),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.description),
                    onPressed: () => _viewReceta(index),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }

  void _viewReceta(int index) {
    final receta = _recetasCocinables[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final dialogHeight =
            screenHeight * 0.5; // Ajusta el porcentaje según tus necesidades

        return AlertDialog(
          title: Text(receta.nombre),
          content: Container(
            width: double.maxFinite,
            height: dialogHeight,
            child: ListView.builder(
              itemCount: receta.idIngredientes.length,
              itemBuilder: (context, index) {
                final ingrediente = Data().getIngrediente(receta.idIngredientes.elementAt(index));
                return ListTile(
                  title: Text(ingrediente.nombre),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
