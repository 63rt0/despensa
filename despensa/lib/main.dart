import 'package:despensa/view/cocinables_page.dart';
import 'package:flutter/material.dart';
import 'view/despensa_page.dart';
import 'view/ingredientes_page.dart';
import 'view/compras_page.dart';
import 'view/recetas_page.dart';

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
        '/despensa': (context) => const DespensaPage(),
        '/cocinables': (context) => const CocinablesPage(),
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
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.egg),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/ingredientes');
            },
          ),
          IconButton(
            icon: Icon(Icons.menu_book),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/recetas');
            },
          ),
          IconButton(
            icon: Icon(Icons.store),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/compras');
            },
          ),
          IconButton(
            icon: Icon(Icons.warehouse),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/despensa');
            },
          ),
          IconButton(
            icon: Icon(Icons.soup_kitchen),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/cocinables');
            },
          ),
        ],
      ),
    );
  }
}
