import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:attandence_system/Screens/instructor_home.dart';
import 'package:attandence_system/Screens/login_screen.dart';
import 'package:attandence_system/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:local_auth/local_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final LocalAuthentication auth = LocalAuthentication();
  final List<BiometricType> availableBiometrics =
      await auth.getAvailableBiometrics();
  print("Available Biometrics: $availableBiometrics");
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //FirebaseAuth.instance.signOut();
    final user = FirebaseAuth.instance.currentUser;
    return AdaptiveTheme(
      light: ThemeData.light(useMaterial3: true),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.black.withOpacity(0.1),
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => GetMaterialApp(
        title: 'Flutter Demo',
        theme: theme,
        darkTheme: darkTheme,
        home: user == null
            ? const LoginScreen()
            : const InstructorHome(
                isStudent: false,
              ),
      ),
    );
  }
}
