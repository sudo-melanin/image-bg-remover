import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/home/presentation/home_screen.dart';

class BgRemoverApp extends StatelessWidget {
  const BgRemoverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Background Remover',
      theme: AppTheme.dark,
      home: const HomeScreen(),
    );
  }
}