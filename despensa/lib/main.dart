import 'package:despensa/view/cocinables_page.dart';
import 'package:flutter/material.dart';
import 'view/despensa_page.dart';
import 'view/ingredientes_page.dart';
import 'view/compra_page.dart';
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const HomePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          case '/ingredientes':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const IngredientesPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          case '/compra':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const CompraPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          case '/recetas':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const RecetasPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          case '/despensa':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const DespensaPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          case '/cocinables':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const CocinablesPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          default:
            return null;
        }
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerNavigation(),
      body: Container(color: Colors.black),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}

class DrawerNavigation extends StatelessWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.egg),
            title: const Text('Ingredientes'),
            onTap: () {
              Navigator.popAndPushNamed(context, '/ingredientes');
            },
          ),
          ListTile(
            leading: const Icon(Icons.soup_kitchen),
            title: const Text('Cocinables'),
            onTap: () {
              Navigator.popAndPushNamed(context, '/cocinables');
            },
          ),
        ],
      ),
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.menu_book),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/recetas');
            },
          ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/despensa');
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/compra');
            },
          )
        ],
      ),
    );
  }
}
