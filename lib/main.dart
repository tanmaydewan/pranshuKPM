import 'package:flutter/material.dart';
import 'package:kpmg_employees/login_page.dart';
import 'package:kpmg_employees/signup_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'orWKXR8IUVmkt8mWWZMOcJakJTiL9S7KaR6C8uKp';
  const keyClientKey = 'ABO40BAD17GKrJHmuhOKFo5UGq3RAWuz2TEjmqZl';
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
            nextScreen:  LogInScreen(),
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
    return SignUp(
    );
  }
}