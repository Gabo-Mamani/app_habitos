import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_routes.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const AppLayout({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed(AppRoutes.home);
        break;
      case 1:
        Get.offAllNamed('/cursos'); // crearás luego esta ruta
        break;
      case 2:
        Get.offAllNamed('/habitos');
        break;
      case 3:
        Get.offAllNamed('/recompensas');
        break;
      case 4:
        Get.offAllNamed('/perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Cursos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle), label: 'Hábitos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events), label: 'Recompensas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
