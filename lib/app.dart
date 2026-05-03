import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'presentation/admin/screens/dashboard_screen.dart';
import 'presentation/admin/screens/landing_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Form Automation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');

    if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'form') {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => LandingScreen(token: uri.pathSegments[1]),
      );
    }

    return MaterialPageRoute(
      settings: settings,
      builder: (_) => DashboardScreen(),
    );
  }
}
