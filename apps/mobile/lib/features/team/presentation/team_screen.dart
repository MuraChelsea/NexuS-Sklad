import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/domain_state_cards.dart';
import '../../../core/widgets/entity_cards.dart';
import '../../../core/widgets/info_cards.dart';
import '../../../core/widgets/state_cards.dart';
import '../../auth/application/auth_controller.dart';
import '../data/company_queue_store.dart';
import '../data/company_repository.dart';
import '../data/user_queue_store.dart';
import '../data/user_repository.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({
    super.key,
    required this.config,
    required this.authController,
    this.companyRepository,
    this.userRepository,
    this.companyPayloadBuilder,
    this.invitePayloadBuilder,
    this.userPayloadBuilder,
  });

  final AppConfig config;
  final AuthController authController;
  final CompanyRepository? companyRepository;
  final UserRepository? userRepository;
  final Future<CompanyPayload?> Function(MobileCompany company)? companyPayloadBuilder;
  final Future<InvitePayload?> Function()? invitePayloadBuilder;
  final Future<UserPayload?> Function(MobileTeamUser user)? userPayloadBuilder;

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  late Future<_TeamViewData> _viewDataFuture;
  final CompanyQueueStore _companyQueueStore = CompanyQueueStore();
  final UserQueueStore _userQueueStore = UserQueueStore();
  final TextEditingController _searchController = TextEditingController();
  bool _busy = false;
  _TeamViewFilter _activeFilter = _TeamViewFilter.all;
  String _searchQuery = '';

  CompanyRepository get _companyRepository =>
      widget.companyRepository ??
      CompanyRepository(
        ApiClient(baseUrl: widget.config.apiBaseUrl),
      );

  UserRepository get _userRepository =>
      widget.userRepository ??
      UserRepository(
        ApiClient(baseUrl: widget.config.apiBaseUrl),
      );

  bool get _isOwner => widget.authController.currentUser?.role == 'OWNER';

  @override
  void initState() {
    super.initState();
    _viewDataFuture = _loadViewData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<_TeamViewData> _loadViewData() async {
    final session = widget.authController.session!;
    final companySync = await _companyRepository.flushPendingUpdate(
      accessToken: session.accessToken,
    );
    final userSync = await _userRepository.flushPendingUpdates(
      accessToken: session.accessToken,
    );
    final company = await _companyRepository.fetchCompany(
      accessToken: session.accessToken,
    );
    await widget.authController.updateCompanyNameLocally(company.name);

    final hasPendingCompanySync = await _companyQueueStore.read() != null;
    final hasPendingUserSync = await _userQueueStore.readAll();
    final pendingUserUpdates = await _userRepository.getPendingUpdates();
    final pendingUserInvites = await _userRepository.getPendingInvites();
    final pendingInviteCount = await _userRepository.getPendingInviteCount();

    if (!_isOwner) {
      return _TeamViewData(
        company: company,
        users: const [],
        hasPendingCompanySync: hasPendingCompanySync,
        hasCompanyConflict: companySync.hasConflict,
        companySyncMessage: companySync.blockingMessage,
        pendingUserUpdateCount: hasPendingUserSync.length + pendingInviteCount,
        pendingUserIds: const <String>{},
        pendingUserUpdates: const [],
        pendingUserInvites: const [],
        hasUserConflict: userSync.hasConflict,
        userSyncMessage: userSync.blockingMessage,
      );
    }

    final users = await _userRepository.fetchUsers(
      accessToken: session.accessToken,
    );

    return _TeamViewData(
      company: company,
      users: users,
      hasPendingCompanySync: hasPendingCompanySync,
      hasCompanyConflict: companySync.hasConflict,
      companySyncMessage: companySync.blockingMessage,
      pendingUserUpdateCount: hasPendingUserSync.length + pendingInviteCount,
      pendingUserIds: hasPendingUserSync.map((item) => item.userId).toSet(),
      pendingUserUpdates: pendingUserUpdates,
      pendingUserInvites: pendingUserInvites,
      hasUserConflict: userSync.hasConflict,
      userSyncMessage: userSync.blockingMessage,
    );
  }

  Future<void> _clearPendingCompanyUpdate() async {
    await _companyRepository.discardPendingUpdate();
    if (!mounted) {
      return;
    }

    setState(() {
      _viewDataFuture = _loadViewData();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Отложенные изменения компании очищены')),
    );
  }

  Future<void> _clearPendingUserUpdates() async {
    await _userRepository.clearPendingUpdates();
    if (!mounted) {
      return;
    }

    setState(() {
      _viewDataFuture = _loadViewData();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Отложенные изменения сотрудников очищены')),
    );
  }

  Future<void> _retryPendingUserUpdate(String userId) async {
    final message = await _userRepository.retryPendingUpdate(
      accessToken: widget.authController.session!.accessToken,
      userId: userId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _viewDataFuture = _loadViewData();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'Изменения по сотруднику повторно отправлены')),
    );
  }

  Future<void> _discardPendingUserUpdate(String userId) async {
    await _userRepository.discardPendingUpdate(userId);

    if (!mounted) {
      return;
    }

    setState(() {
      _viewDataFuture = _loadViewData();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Отложенное изменение по сотруднику удалено')),
    );
  }

  Future<void> _clearPendingInvites() async {
    await _userRepository.clearPendingInvites();
    if (!mounted) {
      return;
    }

    setState(() {
      _viewDataFuture = _loadViewData();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Отложенные приглашения очищены')),
    );
  }

  Future<void> _clearAllPendingUserOperations() async {
    await _userRepository.clearPendingInvites();
    await _userRepository.clearPendingUpdates();
    if (!mounted) {
      return;
    }

    setState(() {
      _viewDataFuture = _loadViewData();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Отложенные изменения по команде очищены')),
    );
  }

  Future<void> _retryPendingInvite(String localId) async {
    final message = await _userRepository.retryPendingInvite(
      accessToken: widget.authController.session!.accessToken,
      localId: localId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _viewDataFuture = _loadViewData();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'Приглашение повторно отправлено')),
    );
  }

  Future<void> _discardPendingInvite(String localId) async {
    await _userRepository.discardPendingInvite(localId);

    if (!mounted) {
      return;
    }

    setState(() {
      _viewDataFuture = _loadViewData();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Отложенное приглашение удалено')),
    );
  }

  Future<void> _showInviteDialog({
    InvitePayload? initialPayload,
    bool allowRetry = true,
  }) async {
    final payload = initialPayload ??
        await (() async {
          if (widget.invitePayloadBuilder case final builder?) {
            return builder();
          }
          return _showInvitePayloadDialog();
        })();

    if (payload == null || payload.email.isEmpty) {
      return;
    }

    setState(() {
      _busy = true;
    });

    try {
      final result = await _userRepository.inviteUser(
        accessToken: widget.authController.session!.accessToken,
        email: payload.email,
        role: payload.role,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _viewDataFuture = _loadViewData();
      });

      if (result.queued) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Приглашение сохранено в очередь на отправку')),
        );
      } else {
        await showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Приглашение готово'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result.user.email),
                  const SizedBox(height: 8),
                  const Text(
                    'Передай этот токен сотруднику, чтобы он завершил подключение к компании.',
                  ),
                  const SizedBox(height: 12),
                  SelectableText(result.inviteToken),
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Закрыть'),
                ),
              ],
            );
          },
        );
      }
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      if (allowRetry && await widget.authController.recoverSession(error)) {
        await _showInviteDialog(
          initialPayload: payload,
          allowRetry: false,
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  Future<void> _showEditCompanyDialog(
    MobileCompany company, {
    CompanyPayload? initialPayload,
    bool allowRetry = true,
  }) async {
    final payload = initialPayload ??
        await (() async {
          if (widget.companyPayloadBuilder case final builder?) {
            return builder(company);
          }
          return _showCompanyPayloadDialog(company);
        })();

    if (payload == null) {
      return;
    }

    setState(() {
      _busy = true;
    });

    try {
      final result = await _companyRepository.updateCompany(
        accessToken: widget.authController.session!.accessToken,
        fallbackCompany: company,
        name: payload.name,
        city: payload.city,
        phone: payload.phone,
      );

      await widget.authController.updateCompanyNameLocally(result.company.name);
      if (!result.queued) {
        await widget.authController.refreshCurrentUser();
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _viewDataFuture = _loadViewData();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.queued
                ? 'Изменения компании сохранены в очередь на отправку'
                : 'Данные компании обновлены',
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      if (allowRetry && await widget.authController.recoverSession(error)) {
        await _showEditCompanyDialog(
          company,
          initialPayload: payload,
          allowRetry: false,
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  Future<void> _showEditUserDialog(
    MobileTeamUser user, {
    UserPayload? initialPayload,
    bool allowRetry = true,
  }) async {
    final payload = initialPayload ??
        await (() async {
          if (widget.userPayloadBuilder case final builder?) {
            return builder(user);
          }
          return _showUserPayloadDialog(user);
        })();

    if (payload == null) {
      return;
    }

    setState(() {
      _busy = true;
    });

    try {
      final result = await _userRepository.updateUser(
        accessToken: widget.authController.session!.accessToken,
        fallbackUser: user,
        userId: user.id,
        name: payload.name,
        email: payload.email,
        phone: payload.phone,
        password: payload.password,
        role: payload.role,
        isActive: payload.isActive,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _viewDataFuture = _loadViewData();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.queued
                ? 'Изменения по сотруднику сохранены в очередь на отправку'
                : 'Данные сотрудника обновлены',
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      if (allowRetry && await widget.authController.recoverSession(error)) {
        await _showEditUserDialog(
          user,
          initialPayload: payload,
          allowRetry: false,
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  Future<InvitePayload?> _showInvitePayloadDialog() async {
    final emailController = TextEditingController();
    var role = 'STAFF';

    final result = await showDialog<InvitePayload>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Пригласить сотрудника'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Создай приглашение для нового сотрудника. Токен можно будет передать вручную.',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      helperText: 'На этот адрес будет создано приглашение',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: role,
                    decoration: const InputDecoration(
                      labelText: 'Роль',
                      helperText: 'Менеджер управляет операциями, сотрудник работает по складу',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'STAFF', child: Text('Сотрудник')),
                      DropdownMenuItem(value: 'MANAGER', child: Text('Менеджер')),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setDialogState(() {
                        role = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Отмена'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                      InvitePayload(
                        email: emailController.text.trim(),
                        role: role,
                      ),
                    );
                  },
                  child: const Text('Создать приглашение'),
                ),
              ],
            );
          },
        );
      },
    );

    emailController.dispose();
    return result;
  }

  Future<CompanyPayload?> _showCompanyPayloadDialog(MobileCompany company) async {
    final nameController = TextEditingController(text: company.name);
    final cityController = TextEditingController(text: company.city ?? '');
    final phoneController = TextEditingController(text: company.phone ?? '');

    final result = await showDialog<CompanyPayload>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать компанию'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Обнови карточку компании. Эти данные видят owner, manager и staff.',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Название',
                  helperText: 'Как компания будет называться в приложении для всей команды',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'Город',
                  helperText: 'Необязательно. Помогает отличать филиалы и точки',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Телефон',
                  helperText: 'Контактный номер для быстрых вопросов по складу',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  return;
                }

                Navigator.of(context).pop(
                  CompanyPayload(
                    name: name,
                    city: _nullIfEmpty(cityController.text),
                    phone: _nullIfEmpty(phoneController.text),
                  ),
                );
              },
              child: const Text('Сохранить компанию'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    cityController.dispose();
    phoneController.dispose();
    return result;
  }

  Future<UserPayload?> _showUserPayloadDialog(MobileTeamUser user) async {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone ?? '');
    final passwordController = TextEditingController();
    var role = user.role;
    var isActive = user.isActive;

    final result = await showDialog<UserPayload>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Редактировать сотрудника'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Обнови роль, контакты и статус сотрудника. Изменения сразу повлияют на его доступ.',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Имя',
                        helperText: 'Как сотрудник будет отображаться в журнале и команде',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        helperText: 'Используется для входа в приложение',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Телефон',
                        helperText: 'Необязательно. Удобно для связи с сотрудником',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: role,
                      decoration: const InputDecoration(
                        labelText: 'Роль',
                        helperText: 'Менеджер управляет операциями, сотрудник работает по складу',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'STAFF', child: Text('Сотрудник')),
                        DropdownMenuItem(value: 'MANAGER', child: Text('Менеджер')),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setDialogState(() {
                          role = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Новый пароль',
                        helperText: 'Оставь пустым, если пароль менять не нужно',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Активен'),
                      value: isActive,
                      onChanged: (value) {
                        setDialogState(() {
                          isActive = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Отмена'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final email = emailController.text.trim();
                    if (name.isEmpty || email.isEmpty) {
                      return;
                    }

                    Navigator.of(context).pop(
                      UserPayload(
                        name: name,
                        email: email,
                        phone: _nullIfEmpty(phoneController.text),
                        role: role,
                        password: _nullIfEmpty(passwordController.text),
                        isActive: isActive,
                      ),
                    );
                  },
                  child: const Text('Сохранить сотрудника'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    return result;
  }

  String? _nullIfEmpty(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _formatPendingDate(DateTime value) {
    String two(int number) => number.toString().padLeft(2, '0');
    return '${two(value.day)}.${two(value.month)} ${two(value.hour)}:${two(value.minute)}';
  }

  String _formatMemberDate(DateTime value) {
    String two(int number) => number.toString().padLeft(2, '0');
    return '${two(value.day)}.${two(value.month)}';
  }

  String _roleLabel(String role) {
    switch (role) {
      case 'OWNER':
        return 'Владелец';
      case 'MANAGER':
        return 'Менеджер';
      case 'STAFF':
        return 'Сотрудник';
      default:
        return role;
    }
  }

  Color _colorForRole(String role) {
    switch (role) {
      case 'OWNER':
        return const Color(0xFF143B2D);
      case 'MANAGER':
        return const Color(0xFF295C9B);
      case 'STAFF':
        return const Color(0xFF9B6A1B);
      default:
        return const Color(0xFF6B7280);
    }
  }

  List<MobileTeamUser> _applySearch(List<MobileTeamUser> users) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return users;
    }

    return users.where((member) {
      return member.name.toLowerCase().contains(query) ||
          member.email.toLowerCase().contains(query) ||
          (member.phone?.toLowerCase().contains(query) ?? false);
    }).toList(growable: false);
  }

  List<MobileTeamUser> _applyFilter(List<MobileTeamUser> users) {
    switch (_activeFilter) {
      case _TeamViewFilter.all:
        return users;
      case _TeamViewFilter.active:
        return users.where((member) => member.isActive).toList(growable: false);
      case _TeamViewFilter.managers:
        return users.where((member) => member.role == 'MANAGER').toList(growable: false);
      case _TeamViewFilter.staff:
        return users.where((member) => member.role == 'STAFF').toList(growable: false);
      case _TeamViewFilter.invites:
        return users.where((member) => member.isPendingInvite).toList(growable: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.authController.currentUser;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Команда',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              if (_isOwner)
                IconButton(
                  onPressed: _busy ? null : _showInviteDialog,
                  icon: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.person_add_alt_1_rounded),
                  tooltip: 'Пригласить',
                ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _viewDataFuture = _loadViewData();
                  });
                },
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Обновить',
              ),
              IconButton(
                onPressed: () {
                  widget.authController.logout();
                },
                icon: const Icon(Icons.logout_rounded),
                tooltip: 'Выйти',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            currentUser == null
                ? 'Владелец управляет доступом, менеджер ведет операции, сотрудник работает по складу.'
                : '${currentUser.name} · ${_roleLabel(currentUser.role)} · ${currentUser.companyName}',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<_TeamViewData>(
              future: _viewDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  if (snapshot.error is ApiException &&
                      widget.authController.isSessionExpiredError(
                        snapshot.error as ApiException,
                      )) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      final recovered = await widget.authController.recoverSession(
                        snapshot.error as ApiException,
                      );
                      if (recovered && mounted) {
                        setState(() {
                          _viewDataFuture = _loadViewData();
                        });
                      }
                    });
                  }
                  final message = snapshot.error is ApiException
                      ? (snapshot.error as ApiException).message
                      : 'Не удалось загрузить команду';
                  return ErrorStateCard(
                    message: message,
                    onRetry: () {
                      setState(() {
                        _viewDataFuture = _loadViewData();
                      });
                    },
                  );
                }
                final data = snapshot.data!;
                final activeUsers = data.users.where((member) => member.isActive).length;
                final managerCount = data.users.where((member) => member.role == 'MANAGER').length;
                final staffCount = data.users.where((member) => member.role == 'STAFF').length;
                final pendingInviteMembers =
                    data.users.where((member) => member.isPendingInvite).length;
                final filteredUsers = _applySearch(_applyFilter(data.users));
                return ListView(
                  children: [
                    if (data.pendingUserUpdateCount > 0 || data.userSyncMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TeamPendingOperationsCard(
                          queueCount: data.pendingUserUpdateCount,
                          invites: data.pendingUserInvites
                              .map(
                                (item) => PendingOperationAction(
                                  id: item.localId,
                                  label:
                                      '${item.email} · ${_roleLabel(item.role)} · ${_formatPendingDate(item.createdAt)}',
                                  onRetry: () => _retryPendingInvite(item.localId),
                                  onDiscard: () => _discardPendingInvite(item.localId),
                                ),
                              )
                              .toList(growable: false),
                          updates: data.pendingUserUpdates
                              .map(
                                (item) => PendingOperationAction(
                                  id: item.userId,
                                  label:
                                      '${item.name} · ${item.role == null ? 'Без роли' : _roleLabel(item.role!)} · ${_formatPendingDate(item.createdAt)}',
                                  onRetry: () => _retryPendingUserUpdate(item.userId),
                                  onDiscard: () => _discardPendingUserUpdate(item.userId),
                                ),
                              )
                              .toList(growable: false),
                          syncMessage: data.userSyncMessage,
                          hasConflict: data.hasUserConflict,
                          onSyncAll: data.hasUserConflict
                              ? null
                              : () {
                                  setState(() {
                                    _viewDataFuture = _loadViewData();
                                  });
                                },
                          onClearAll:
                              data.hasUserConflict ? null : _clearAllPendingUserOperations,
                          onClearInvites:
                              data.hasUserConflict ? _clearPendingInvites : null,
                          onClearConflict:
                              data.hasUserConflict ? _clearPendingUserUpdates : null,
                        ),
                      ),
                    CompanyStatusCard(
                      name: data.company.name,
                      details: [
                        if (data.company.city != null && data.company.city!.isNotEmpty)
                          data.company.city!,
                        if (data.company.phone != null && data.company.phone!.isNotEmpty)
                          data.company.phone!,
                      ].join(' · ').isEmpty
                          ? 'Город и телефон пока не заполнены'
                          : [
                              if (data.company.city != null && data.company.city!.isNotEmpty)
                                data.company.city!,
                              if (data.company.phone != null && data.company.phone!.isNotEmpty)
                                data.company.phone!,
                            ].join(' · '),
                      canEdit: _isOwner,
                      hasPendingSync: data.hasPendingCompanySync,
                      hasConflict: data.hasCompanyConflict,
                      syncMessage: data.companySyncMessage,
                      onEdit: _isOwner ? () => _showEditCompanyDialog(data.company) : null,
                      onSync: _isOwner
                          ? () {
                              setState(() {
                                _viewDataFuture = _loadViewData();
                              });
                            }
                          : null,
                      onClearConflict: _isOwner && data.hasCompanyConflict
                          ? _clearPendingCompanyUpdate
                          : null,
                    ),
                    const SizedBox(height: 12),
                    if (_isOwner && data.users.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Chip(label: Text('Сотрудников: ${data.users.length}')),
                            Chip(label: Text('Активных: $activeUsers')),
                            Chip(label: Text('Менеджеров: $managerCount')),
                            Chip(label: Text('Сотрудников склада: $staffCount')),
                            Chip(label: Text('Приглашений: $pendingInviteMembers')),
                          ],
                        ),
                      ),
                    if (!_isOwner)
                      const InfoMessageCard(
                        message:
                            'Список сотрудников и приглашения доступны роли владельца. '
                            'Менеджер и сотрудник видят текущую компанию и свой доступ.',
                      ),
                    if (_isOwner && data.users.isEmpty)
                      const InfoMessageCard(
                        message: 'В компании пока нет сотрудников кроме владельца.',
                      ),
                    if (_isOwner) ...[
                      Text(
                        'Сотрудники',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      if (data.users.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Поиск по команде',
                                  hintText: 'Имя, email или телефон',
                                  prefixIcon: const Icon(Icons.search_rounded),
                                  suffixIcon: _searchQuery.isEmpty
                                      ? null
                                      : IconButton(
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {
                                              _searchQuery = '';
                                            });
                                          },
                                          icon: const Icon(Icons.close_rounded),
                                          tooltip: 'Очистить поиск',
                                        ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _TeamFilterChips(
                                activeFilter: _activeFilter,
                                allCount: data.users.length,
                                activeCount: activeUsers,
                                managerCount: managerCount,
                                staffCount: staffCount,
                                inviteCount: pendingInviteMembers,
                                onSelected: (filter) {
                                  setState(() {
                                    _activeFilter = filter;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      if (filteredUsers.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _searchQuery.isNotEmpty
                                        ? 'Поиск не дал сотрудников по текущему фильтру.'
                                        : 'По выбранному фильтру сотрудников нет.',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _activeFilter = _TeamViewFilter.all;
                                          });
                                        },
                                        child: const Text('Сбросить фильтр'),
                                      ),
                                      if (_searchQuery.isNotEmpty)
                                        TextButton(
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {
                                              _searchQuery = '';
                                            });
                                          },
                                          child: const Text('Очистить поиск'),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        ...filteredUsers.map(
                          (member) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TeamMemberInfoCard(
                              name: member.name,
                              subtitle: [
                                member.email,
                                if (member.phone != null && member.phone!.isNotEmpty) member.phone!,
                                if (member.isPendingInvite)
                                  'Приглашение до ${_formatMemberDate(member.inviteExpiresAt!)}',
                                if (!member.isActive && !member.isPendingInvite) 'Неактивен',
                              ].join(' · '),
                              role: member.role,
                              accent: _colorForRole(member.role),
                              canEdit: true,
                              hasPendingSync: data.pendingUserIds.contains(member.id),
                              onTap: () => _showEditUserDialog(member),
                            ),
                          ),
                        ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamViewData {
  const _TeamViewData({
    required this.company,
    required this.users,
    required this.hasPendingCompanySync,
    required this.hasCompanyConflict,
    required this.companySyncMessage,
    required this.pendingUserUpdateCount,
    required this.pendingUserIds,
    required this.pendingUserUpdates,
    required this.pendingUserInvites,
    required this.hasUserConflict,
    required this.userSyncMessage,
  });

  final MobileCompany company;
  final List<MobileTeamUser> users;
  final bool hasPendingCompanySync;
  final bool hasCompanyConflict;
  final String? companySyncMessage;
  final int pendingUserUpdateCount;
  final Set<String> pendingUserIds;
  final List<PendingUserUpdateView> pendingUserUpdates;
  final List<PendingUserInviteView> pendingUserInvites;
  final bool hasUserConflict;
  final String? userSyncMessage;
}

enum _TeamViewFilter {
  all,
  active,
  managers,
  staff,
  invites,
}

class _TeamFilterChips extends StatelessWidget {
  const _TeamFilterChips({
    required this.activeFilter,
    required this.allCount,
    required this.activeCount,
    required this.managerCount,
    required this.staffCount,
    required this.inviteCount,
    required this.onSelected,
  });

  final _TeamViewFilter activeFilter;
  final int allCount;
  final int activeCount;
  final int managerCount;
  final int staffCount;
  final int inviteCount;
  final ValueChanged<_TeamViewFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    final chips = <({String label, _TeamViewFilter filter})>[
      (label: 'Все ($allCount)', filter: _TeamViewFilter.all),
      (label: 'Активные ($activeCount)', filter: _TeamViewFilter.active),
      (label: 'Менеджеры ($managerCount)', filter: _TeamViewFilter.managers),
      (label: 'Сотрудники ($staffCount)', filter: _TeamViewFilter.staff),
      (label: 'Приглашения ($inviteCount)', filter: _TeamViewFilter.invites),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips
          .map(
            (chip) => ChoiceChip(
              label: Text(chip.label),
              selected: activeFilter == chip.filter,
              onSelected: (_) => onSelected(chip.filter),
            ),
          )
          .toList(growable: false),
    );
  }
}

class InvitePayload {
  const InvitePayload({
    required this.email,
    required this.role,
  });

  final String email;
  final String role;
}

class CompanyPayload {
  const CompanyPayload({
    required this.name,
    required this.city,
    required this.phone,
  });

  final String name;
  final String? city;
  final String? phone;
}

class UserPayload {
  const UserPayload({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.password,
    required this.isActive,
  });

  final String name;
  final String email;
  final String? phone;
  final String role;
  final String? password;
  final bool isActive;
}
