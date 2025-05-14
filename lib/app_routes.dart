import 'package:app_habitos/pages/cursos/curso_detail_page.dart';
import 'package:app_habitos/pages/cursos/cursos_page.dart';
import 'package:app_habitos/pages/habitos/crear_habito_page.dart';
import 'package:app_habitos/pages/habitos/habitos_page.dart';
import 'package:app_habitos/pages/perfil/perfil_page.dart';
import 'package:app_habitos/pages/recompensas/recompensas_page.dart';
import 'package:get/get.dart';
import 'pages/landing_page.dart';
import 'pages/home_page.dart';

class AppRoutes {
  static const landing = '/';
  static const home = '/home';
  static const cursos = '/cursos';
  static const habitos = '/habitos';
  static const recompensas = '/recompensas';
  static const perfil = '/perfil';
  static const crearHabito = '/crear-habito';

  static final routes = [
    GetPage(name: landing, page: () => const LandingPage()),
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: cursos, page: () => const CursosPage()),
    GetPage(
      name: '/curso-detail',
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return CursoDetailPage(titulo: args['titulo']);
      },
    ),
    GetPage(name: habitos, page: () => const HabitosPage()),
    GetPage(name: recompensas, page: () => const RecompensasPage()),
    GetPage(name: perfil, page: () => const PerfilPage()),
    GetPage(name: crearHabito, page: () => const CrearHabitoPage()),
  ];
}
