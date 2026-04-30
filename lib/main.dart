import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'utils/theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String language = 'en';

  void _changeLanguage(String newLanguage) {
    setState(() {
      language = newLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DarzeeBook',
      theme: AppTheme.getTheme(),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        language: language,
        onLanguageChange: _changeLanguage,
      ),
      locale: Locale(language),
      supportedLocales: const [
        Locale('en'),
        Locale('ur'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

