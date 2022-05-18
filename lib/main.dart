import 'package:flutter/material.dart';
import 'package:kpmg_employees/login_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = '5hiuw32AotnUJ9ma5FBR41ECeNM9ACJvE8SCTXwT';
  const keyClientKey = 'ViVyOrPd60XcxyKVpFUyB7xmnaTTydTZafjvEnIN';
  const keyParseServerUrl = 'https://parseapi.back4app.com/';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Clean Code',
        home: AnimatedSplashScreen(
            duration: 1250,
            splash: 'assets/splashimage.png',
            nextScreen: const LoginPage(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.topToBottom,
            animationDuration: const Duration(seconds: 2),
            backgroundColor: const Color(0xff122965)));
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LoginPage(
    );
  }
}