import 'package:get/get.dart';
import '../pages/landing_page.dart';
import '../pages/home_page.dart';

class NavigationController extends GetxController {
  void goToHome() {
    Get.to(() => const HomePage());
  }

  void goToLanding() {
    Get.offAll(() => const LandingPage());
  }
}
