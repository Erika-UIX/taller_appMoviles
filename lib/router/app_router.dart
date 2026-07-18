import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/screens/screens.dart';

final GlobalKey<NavigatorState> _rootNavigatiorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final goRouter = GoRouter(
  initialLocation: '/login',
  navigatorKey: _rootNavigatiorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeLayout(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/alumnos',
              builder: (context, state) => const AlumnosScreen(),
              routes: [
                // Sub-ruta para CREAR (Ej: /alumnos/nuevo)
                GoRoute(
                  path: '/nuevo',
                  builder: (context, state) => const AlumnoFormScreen(),
                ),
                // Sub-ruta para MODIFICAR (Ej: /alumnos/editar)
                // Pasamos los datos actuales a través del 'extra' de go_router
                GoRoute(
                  path: '/editar',
                  builder: (context, state) {
                    final alumno = state.extra as Map<String, dynamic>?;
                    return AlumnoFormScreen(
                      id: alumno?['id'],
                      name: alumno?['name'],
                      enrollment: alumno?['enrollment'],
                      career: alumno?['career'],
                      isActive: alumno?['isActive'],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/materias',
              builder: (context, state) => const MateriasScreen(),
              routes: [
                // Sub-ruta para CREAR materias
                GoRoute(
                  path: '/nuevo',
                  builder: (context, state) => const MateriaFormScreen(),
                ),
                // Sub-ruta para MODIFICAR materias
                GoRoute(
                  path: '/editar',
                  builder: (context, state) {
                    final materia = state.extra as Map<String, dynamic>?;
                    return MateriaFormScreen(
                      id: materia?['id'],
                      code: materia?['code'],
                      name: materia?['name'],
                      credits: materia?['credits'],
                      department: materia?['department'],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/asignacion',
              builder: (context, state) => const AsignacionScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
