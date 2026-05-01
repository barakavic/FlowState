import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/commander_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: FlowstateApp(),
    ),
  );
}

class FlowstateApp extends StatelessWidget {
  const FlowstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flowstate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1117),
        useMaterial3: true,
      ),
      home: const CommanderScreen(),
    );
  }
}
