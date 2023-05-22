import 'package:flutter/material.dart';
import 'ingredientes_page.dart';
import 'compras_page.dart';
import 'recetas_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Despensa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/ingredientes': (context) => const IngredientesPage(),
        '/compras': (context) => const ComprasPage(),
        '/recetas': (context) => const RecetasPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.black),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.store, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/compras');
              },
            ),
            IconButton(
                icon: Icon(Icons.egg),
                onPressed: () {
                  Navigator.pushNamed(context, '/ingredientes');
                }),
            IconButton(
                icon: Icon(Icons.menu_book),
                onPressed: () {
                  Navigator.pushNamed(context, '/recetas');
                }),
          ],
        ),
      ),
    );
  }
}
