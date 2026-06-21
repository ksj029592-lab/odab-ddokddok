import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:odab_ddokddok/features/auth/application/auth_providers.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await ref.read(authServiceProvider).getCurrentUser();
    if (!mounted) return;

    if (user == null) {
      ref.read(authLoggedInProvider.notifier).state = false;
      context.go('/login');
      return;
    }

    _displayNameController.text = user.fullName;
  _userIdController.text = user.userId;
    _schoolController.text = user.school;
    _phoneController.text = user.phone;
    _gradeController.text = user.grade;

    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _userIdController.dispose();
    _schoolController.dispose();
    _phoneController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_loading) return;

    await ref.read(authServiceProvider).updateCurrentUser(
          fullName: _displayNameController.text.trim(),
          phone: _phoneController.text.trim(),
          school: _schoolController.text.trim(),
          grade: _gradeController.text.trim(),
        );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('계정 정보가 저장되었어요')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계정 정보'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/'),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFF8FAFC), Color(0xFFE0F2FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  const Text(
                    '로그인한 계정 정보를 수정할 수 있어요',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: _displayNameController,
                            decoration: const InputDecoration(
                              labelText: '표시 이름',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _userIdController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: '아이디',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: '전화번호',
                              prefixIcon: Icon(Icons.call_outlined),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _schoolController,
                            decoration: const InputDecoration(
                              labelText: '학교/소속',
                              prefixIcon: Icon(Icons.school_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _gradeController,
                            decoration: const InputDecoration(
                              labelText: '학년',
                              prefixIcon: Icon(Icons.badge_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _save,
                              icon: const Icon(Icons.save_outlined),
                              label: const Text('저장'),
                            ),
                          ),
                        ],
                      ),
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
