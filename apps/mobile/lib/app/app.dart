import 'package:flutter/material.dart';

import '../core/config/app_config.dart';
import '../core/network/api_client.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/application/auth_controller.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/shell/presentation/app_shell.dart';

class NexusSkladApp extends StatefulWidget {
  const NexusSkladApp({super.key});

  @override
  State<NexusSkladApp> createState() => _NexusSkladAppState();
}

class _NexusSkladAppState extends State<NexusSkladApp> {
  late final AppConfig _config;
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _config = AppConfig.fromEnvironment();
    _authController = AuthController(
      AuthRepository(ApiClient(baseUrl: _config.apiBaseUrl)),
    );
    _authController.bootstrap();
  }

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _authController,
      builder: (context, _) {
        return MaterialApp(
          title: 'NexusSklad',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          home: _authController.status == AuthStatus.loading
              ? const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : _authController.session == null
              ? LoginScreen(
                  controller: _authController,
                  config: _config,
                )
              : AppShell(
                  config: _config,
                  authController: _authController,
                ),
        );
      },
    );
  }
}
