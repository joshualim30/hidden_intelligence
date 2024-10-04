// main.dart
// Hidden Intelligence - A Game with Trust Issues!

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:hidden_intelligence/mobile/gameplay/waiting_room.dart';
import 'package:hidden_intelligence/mobile/navigation/home.dart';
import 'package:hidden_intelligence/mobile/navigation/join.dart';
import 'package:hidden_intelligence/resources/in_app_purchases/in_app_purchases.dart';
import 'package:hidden_intelligence/web/navigation/home.dart';
import 'package:hidden_intelligence/web/pages/about.dart';
import 'package:hidden_intelligence/web/pages/privacy_policy.dart';
import 'package:hidden_intelligence/web/pages/support.dart';
import 'package:hidden_intelligence/web/pages/under_development.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'firebase_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

// MARK: Main Function
Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // If the app is mobile, initialize AdMob
  if (!kIsWeb) {
    // Initialize AdMob
    unawaited(MobileAds.instance.initialize());
    // Load the .env file
    await dotenv.load(fileName: ".env");
  } else {
    // Use Path URL strategy
    usePathUrlStrategy();
  }

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app
  runApp(const MainApp());
}

// MARK: IAP Connection
class IAPConnection {
  static InAppPurchase? _instance;
  static set instance(InAppPurchase value) {
    _instance = value;
  }

  static InAppPurchase get instance {
    _instance ??= InAppPurchase.instance;
    return _instance!;
  }
}

// MARK: Main App
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return MaterialApp(
        themeMode: ThemeMode.system,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          fontFamily: 'Inconsolata',
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          fontFamily: 'Inconsolata',
        ),
        home: const Scaffold(
          body: Center(
            child: UnderDevelopment(),
          ),
        ),
        // initialRoute: '/',
        // routes: {
        //   '/': (context) =>
        //       const Scaffold(body: Center(child: HomeScreenWeb())),
        //   '/waiting_room': (context) =>
        //       const Scaffold(body: Center(child: WaitingRoomScreen(
        //         emoji: '👑',
        //         deviceId: 'host',
        //         username: 'Host',
        //       ))),
        //   '/join': (context) =>
        //       const Scaffold(body: Center(child: JoinScreen(
        //         emoji: '👑',
        //         deviceId: 'host',
        //         username: 'Host',
        //       ))),
        //   '/about': (context) => const Scaffold(body: Center(child: About())),
        //   '/privacy_policy': (context) =>
        //       const Scaffold(body: Center(child: PrivacyPolicy())),
        //   '/support': (context) =>
        //       const Scaffold(body: Center(child: Support())),
        // },
      );
    }
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        fontFamily: 'Metropolis',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        fontFamily: 'Metropolis',
      ),
      home: Scaffold(
        body: Center(
          child: HomeScreen(),
        ),
      ),
    );
  }
}

// MARK: Color Schemes
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color.fromARGB(255, 36, 112, 255),
  onPrimary: Color.fromRGBO(255, 255, 255, 1),
  primaryContainer: Color.fromARGB(255, 250, 250, 250),
  onPrimaryContainer: Color.fromARGB(255, 0, 0, 0),
  secondary: Color.fromARGB(255, 72, 165, 200),
  onSecondary: Color.fromARGB(255, 255, 255, 255),
  secondaryContainer: Color.fromARGB(255, 240, 240, 240),
  onSecondaryContainer: Color.fromARGB(255, 0, 0, 0),
  error: Color.fromARGB(255, 176, 0, 32),
  onError: Color.fromARGB(255, 255, 255, 255),
  surface: Color.fromARGB(255, 240, 240, 240),
  onSurface: Color.fromARGB(255, 0, 0, 0),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color.fromARGB(255, 36, 112, 255),
  onPrimary: Color.fromARGB(255, 255, 255, 255),
  primaryContainer: Color.fromARGB(255, 20, 20, 20),
  onPrimaryContainer: Color.fromARGB(255, 255, 255, 255),
  secondary: Color.fromARGB(255, 72, 165, 200),
  onSecondary: Color.fromARGB(255, 255, 255, 255),
  secondaryContainer: Color.fromARGB(255, 40, 40, 40),
  onSecondaryContainer: Color.fromARGB(255, 255, 255, 255),
  error: Color.fromARGB(255, 176, 0, 32),
  onError: Color.fromARGB(255, 255, 255, 255),
  surface: Color.fromARGB(255, 20, 20, 20),
  onSurface: Color.fromARGB(255, 255, 255, 255),
);
