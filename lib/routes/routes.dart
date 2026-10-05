import 'package:get/get.dart';
import 'package:mashhorbazar/bindings/basebinding.dart';
import 'package:mashhorbazar/bindings/sign_in_binding.dart';
import 'package:mashhorbazar/bindings/splash_binding.dart';
import 'package:mashhorbazar/screens/base_screen.dart';
import 'package:mashhorbazar/screens/sign_up_screen.dart';
import 'package:mashhorbazar/screens/welcomescreen.dart';
import 'package:mashhorbazar/splash_screen.dart';
import '../screens/sign_in_screen.dart';

const String splash = '/splash-screen';
const String welcomescreen = '/welcome-screen';
const String signinscreen = '/sign-in-screen';
const String signiupcreen = '/sign-up-screen';
const String basescreen = '/base-screen';

List<GetPage> myroutes = [
  GetPage(name: splash, page: () => SplashScreen(), binding: SplashBinding()),
  GetPage(name: welcomescreen, page: () => Welcomescreen()),
  GetPage(
    name: signinscreen,
    page: () => SignInScreen(),
    binding: SignInControllerBinding(),
  ),
  GetPage(
    name: signiupcreen,
    page: () => SignUpScreen(),
    // binding: SignInControllerBinding(),
  ),
  GetPage(name: basescreen, page: () => BaseScreen(), binding: Basebinding()),
];
