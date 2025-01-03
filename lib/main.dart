import 'package:application/controllers/achievements_controller.dart';
import 'package:application/controllers/activity_controller.dart';
import 'package:application/controllers/article_controller.dart';
import 'package:application/controllers/auth_controller.dart';
import 'package:application/controllers/bingocard_controller.dart';
import 'package:application/controllers/chathistory_controller.dart';
import 'package:application/screens/signin_screen.dart';
import 'package:application/screens/splash_screen.dart';
import 'package:application/themes/theme.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'controllers/user_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthController()),
    ChangeNotifierProvider(create: (context) => UserController()), // Add UserController
    ChangeNotifierProvider(create: (context) => BingoCardController()),
    ChangeNotifierProvider(create: (context) => ActivityController()),
    ChangeNotifierProvider(create: (context) => ArticleController()),
    ChangeNotifierProvider(create: (context) => AchievementController()),
    ChangeNotifierProvider(create: (context) => ChatHistoryController()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }
}
