import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muscle_lab_3/view/start_up/login_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const kColorPrimary = Color(0xFF18345c);
const kColorSecondPrimary = Color(0xFF6495ed);
const kColorAppbarText = Color(0xFFFFFFFF);
const kColorMainText = Color(0xFF000000);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muscle Lab',
      localizationsDelegates: AppLocalizations.localizationsDelegates, // 追加
      supportedLocales: AppLocalizations.supportedLocales,             // 追加
      theme: ThemeData(
        primaryColor: kColorPrimary,
      ),
      home: LoginPage(),
    );
  }
}