import 'package:application/controllers/achievements_controller.dart';
import 'package:application/controllers/activity_controller.dart';
import 'package:application/controllers/article_controller.dart';
import 'package:application/controllers/auth_controller.dart';
import 'package:application/controllers/bingocard_controller.dart';
import 'package:application/controllers/notification_controller.dart';
import 'package:application/controllers/store_controller.dart';
import 'package:application/controllers/chathistory_controller.dart';
import 'package:application/controllers/track_activity_controller.dart';
import 'package:application/controllers/track_bingocard_controller.dart';
import 'package:application/screens/signin_screen.dart';
import 'package:application/screens/splash_screen.dart';
import 'package:application/themes/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  final fcmToken=await FirebaseMessaging.instance.getToken();
  print("*********************************************");
  print(fcmToken);
  print("*********************************************");
  await dotenv.load(fileName: ".env");

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthController()),
    ChangeNotifierProvider(create: (context) => UserController()),
    ChangeNotifierProvider(create: (context) => BingoCardController()),
    ChangeNotifierProvider(create:(context) => StoreController()),
    ChangeNotifierProvider(create: (context) => ActivityController()),
    ChangeNotifierProvider(create: (context) => ArticleController()),
    ChangeNotifierProvider(create: (context) => AchievementController()),
    ChangeNotifierProvider(create: (context) => ChatHistoryController()),
    ChangeNotifierProvider(create: (context) => TrackActivityController()),
    ChangeNotifierProvider(create: (context) => TrackBingoCardController()),
    ChangeNotifierProvider(create: (context) => NotificationController()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
