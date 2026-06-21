import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:odab_ddokddok/core/domain/entities/problem.dart' as domain;
import 'package:odab_ddokddok/core/services/providers/problem_providers.dart';
import 'package:odab_ddokddok/features/auth/application/auth_providers.dart';

/// Home screen - main entry point after onboarding
/// 
/// Displays:
/// - Today's review count
/// - Learning statistics
/// - Recent problems
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoggedIn = ref.watch(authLoggedInProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('오답똑똑'),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu_rounded),
            onSelected: (String value) {
              switch (value) {
                case 'library':
                  context.go('/library');
                  break;
                case 'settings':
                  context.go('/settings');
                  break;
                case 'login':
                  context.go('/login');
                  break;
                case 'signup':
                  context.go('/signup');
                  break;
                case 'account':
                  context.go('/account');
                  break;
                case 'logout':
                  ref.read(authServiceProvider).signOut();
                  ref.read(authLoggedInProvider.notifier).state = false;
                  context.go('/');
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'library',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.library_books_outlined),
                  title: Text('라이브러리'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'settings',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.settings_outlined),
                  title: Text('설정'),
                ),
              ),
              if (!isLoggedIn)
                const PopupMenuItem<String>(
                  value: 'login',
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.login_rounded),
                    title: Text('로그인'),
                  ),
                ),
              if (!isLoggedIn)
                const PopupMenuItem<String>(
                  value: 'signup',
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.person_add_alt_1_rounded),
                    title: Text('회원가입'),
                  ),
                ),
              if (isLoggedIn)
                const PopupMenuItem<String>(
                  value: 'account',
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.manage_accounts_outlined),
                    title: Text('계정 정보'),
                  ),
                ),
              if (isLoggedIn)
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.logout_rounded),
                    title: Text('로그아웃'),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[Color(0xFFE0F2FE), Color(0xFFF8FAFC), Color(0xFFECFEFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned(
            top: -80,
            right: -20,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x6622D3EE),
              ),
            ),
          ),
          Positioned(
            top: 90,
            left: -80,
            child: Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x6634D399),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    '오늘의 학습 대시보드',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '오답 복습을 게임처럼, 성장은 숫자로',
                    style: TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  _buildHeroCard(),
                  const SizedBox(height: 16),
                  _buildReviewCard(context),
                  const SizedBox(height: 20),
                  _buildStatsSection(context, ref),
                  const SizedBox(height: 22),
                  const Text(
                    '최근 문제',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: const _RecentProblemsSection(),
                    ),
                  ),
                  const SizedBox(height: 92),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 14,
            child: SafeArea(
              top: false,
              child: Center(
                child: GestureDetector(
                  onTap: () => context.go('/scan'),
                  child: Container(
                    width: 92,
                    height: 92,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: <Color>[Color(0xFF0EA5E9), Color(0xFF14B8A6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Color(0x330F172A),
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.center_focus_strong_rounded, color: Colors.white, size: 34),
                        SizedBox(height: 4),
                        Text(
                          '스캔',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF0EA5E9), Color(0xFF14B8A6), Color(0xFF22C55E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x3D0284C7),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '오늘도 한 문제씩 확실하게',
            style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8),
          Text(
            '스캔하고, 분류하고, 복습 루틴으로 실력 상승 곡선을 만드세요.',
            style: TextStyle(color: Color(0xFFE0F2FE), height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFBFDBFE)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x1A0284C7),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 62,
            height: 62,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: <Color>[Color(0xFF38BDF8), Color(0xFF14B8A6)],
              ),
            ),
            child: const Icon(Icons.bolt, color: Colors.white, size: 34),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('오늘의 복습', style: TextStyle(fontWeight: FontWeight.w800)),
                SizedBox(height: 4),
                Text('0/0', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          FilledButton.tonalIcon(
            onPressed: () => context.go('/review'),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('복습 시작'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, WidgetRef ref) {
    final Map<String, domain.Problem> uniqueProblems = <String, domain.Problem>{};

    for (final domain.Subject subject in domain.Subject.values) {
      final List<domain.Problem> subjectProblems = ref.watch(problemsBySubjectProvider(subject)).valueOrNull ?? <domain.Problem>[];
      for (final domain.Problem p in subjectProblems) {
        uniqueProblems[p.id] = p;
      }
    }

    final List<domain.Problem> dueProblems = ref.watch(dueProblemsProvider(DateTime.now())).valueOrNull ?? <domain.Problem>[];

    final int totalProblems = uniqueProblems.length;
    final int totalWrongCount = uniqueProblems.values.fold<int>(0, (int sum, domain.Problem p) => sum + p.wrongCount);
    final String avgWrong = totalProblems == 0 ? '0.0' : (totalWrongCount / totalProblems).toStringAsFixed(1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Text(
                '학습 통계',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.go('/stats'),
                child: const Text('자세히 보기'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: _StatTile(
                  title: '저장된 문제',
                  value: '$totalProblems개',
                  accent: const Color(0xFF0284C7),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatTile(
                  title: '오늘 복습 대상',
                  value: '${dueProblems.length}개',
                  accent: const Color(0xFF0F766E),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatTile(
                  title: '평균 오답',
                  value: '$avgWrong회',
                  accent: const Color(0xFF7C3AED),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.title, required this.value, required this.accent});

  final String title;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: accent.withValues(alpha: 0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: accent),
          ),
        ],
      ),
    );
  }
}

class _RecentProblemsSection extends StatelessWidget {
  const _RecentProblemsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFBFDBFE)),
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFFFFFFF), Color(0xFFEFF6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Row(
        children: <Widget>[
          Icon(Icons.auto_awesome, color: Color(0xFF0EA5E9)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '최근 문제 없음\n첫 문제를 스캔하면 여기에 학습 히스토리가 쌓여요.',
              style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF334155), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
