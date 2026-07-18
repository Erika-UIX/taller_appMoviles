import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const HomeLayout({super.key, required this.navigationShell});

  static const List<String> _titles = [
    'Gestión de Alumnos',
    'Control de Materias',
    'Asignación de Cursos',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[navigationShell.currentIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person_rounded,
                  size: 40,
                  color: Color(0XFF1A237E),
                ),
              ),
              accountName: const Text(
                'Administrador',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              accountEmail: const Text('admin@aitec.edu.ec'),
              decoration: const BoxDecoration(color: Color(0xFF1A237E)),
            ),
            ListTile(
              leading: const Icon(Icons.school_rounded),
              title: const Text('Alumnos'),
              selected: navigationShell.currentIndex == 0,
              onTap: () => _onTabTapped(context, 0),
            ),
            ListTile(
              leading: const Icon(Icons.book_rounded),
              title: const Text('Materias'),
              selected: navigationShell.currentIndex == 1,
              onTap: () => _onTabTapped(context, 1),
            ),
            ListTile(
              leading: const Icon(Icons.assignment_turned_in_rounded),
              title: const Text('Asignar Cursos'),
              selected: navigationShell.currentIndex == 2,
              onTap: () => _onTabTapped(context, 2),
            ),
            const Divider(),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                // Navega fuera del shell destruyendo el historial hacia el login
                context.go('/login');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      body: navigationShell,
    );
  }

  void _onTabTapped(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      // Mantiene la navegación inicial de la rama si el usuario vuelve a presionar el botón
      initialLocation: index == navigationShell.currentIndex,
    );
    Navigator.pop(context); // Cierra el Drawer automáticamente
  }
}
