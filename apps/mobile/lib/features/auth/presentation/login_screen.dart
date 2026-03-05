import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../application/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.controller,
    required this.config,
  });

  final AuthController controller;
  final AppConfig config;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: 'owner@nexussklad.local');
    _passwordController = TextEditingController(text: 'demo-owner-123');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = widget.controller.status == AuthStatus.loading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF193F31), Color(0xFF2A6A53)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warehouse_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 28),
                        Text(
                          'Рабочий вход в NexusSklad',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Подключение: ${widget.config.apiBaseUrl}',
                          style: const TextStyle(
                            color: Color(0xDEFFFFFF),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.alternate_email_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Пароль',
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                    ),
                  ),
                  if (widget.controller.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      widget.controller.errorMessage!,
                      style: const TextStyle(
                        color: Color(0xFF9C2F1F),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  if (widget.controller.noticeMessage != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E7C2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        widget.controller.noticeMessage!,
                        style: const TextStyle(
                          color: Color(0xFF6E5220),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F0E6),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Демо-аккаунты',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Владелец: owner@nexussklad.local / demo-owner-123\n'
                          'Менеджер: manager@nexussklad.local / demo-manager-123\n'
                          'Сотрудник: staff@nexussklad.local / demo-staff-123',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF5D655E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              await widget.controller.login(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                            },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Войти'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Используй владельца для управления компанией, менеджера для операционной работы, сотрудника для складских сценариев.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF777E78),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
