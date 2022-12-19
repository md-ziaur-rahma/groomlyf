import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'controllers/agora_controllers.dart';
import 'notification/notification_service.dart';
import 'providers/shop_registration.dart';
import 'providers/upload_provider.dart';
import 'ui/screens/forgot_password.dart';
import 'ui/screens/home.dart';
import 'ui/screens/sign_in.dart';
import 'ui/screens/sign_up.dart';
import 'ui/screens/splash.dart';
import 'util/state_widget.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // get user's permission for notification
    //  NotificationService.initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groomlyfe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.green,
        // cursorColor: Colors.green,
      ),
      routes: {
        '/': (context) => Splash(),
        '/home': (context) => HomeScreen(),
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FlutterStatusbarcolor.setStatusBarColor(Colors.grey[400]);
  // FlutterStatusbarTextColor.setTextColor(FlutterStatusbarTextColor.light);
  await NotificationService.initFirebaseConfig();

  StateWidget stateWidget = StateWidget(
    child: MultiProvider(
      providers: [
        Provider(create: (context) => ShopRegistrationProvider()),
        ChangeNotifierProvider(create: (context) => UploadProvider()),
        ChangeNotifierProvider(create: (context) => AdsProvider()),
        ChangeNotifierProvider(create: (context) => AgoraProvider())
      ],
      child: MyApp(),
    ),
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(stateWidget);
}
