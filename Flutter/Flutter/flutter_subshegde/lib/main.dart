import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_subshegde/preview/add_file.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  runApp(await initializeApp());
}

Future<Widget> initializeApp() async {
  return MyApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      title: 'HRM SMART LABS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      home: AddFile(),
    );
  }
}
