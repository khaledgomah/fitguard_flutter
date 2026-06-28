import 'package:flutter/material.dart';

class FitguardApp extends StatelessWidget {
  const FitguardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Fitguard',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('FitGuard'),
        ),
      ),
    );
  }
}