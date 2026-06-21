import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odab_ddokddok/features/auth/application/auth_providers.dart';
import 'package:odab_ddokddok/features/library/presentation/widgets/keyword_filter_chip.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  static const List<_ProblemItem> _items = <_ProblemItem>[
    _ProblemItem(title: '이차함수 최대/최소', subject: '수학', keywords: <String>['함수', '그래프', '최대최소']),
    _ProblemItem(title: '삼각비 응용', subject: '수학', keywords: <String>['삼각비', '도형', '응용']),
    _ProblemItem(title: '문장 구조 해석', subject: '영어', keywords: <String>['문법', '독해', '구문']),
    _ProblemItem(title: '비문학 추론', subject: '국어', keywords: <String>['독해', '추론', '비문학']),
    _ProblemItem(title: '화학 반응식', subject: '과학', keywords: <String>['화학', '반응식', '계산']),
  ];

  String _selectedKeyword = '전체';

  @override
  Widget build(BuildContext context) {
    final Set<String> allKeywords = <String>{'전체'};
    for (final _ProblemItem item in _items) {
      allKeywords.addAll(item.keywords);
    }

    final bool isLoggedIn = ref.watch(authLoggedInProvider);

    final List<_ProblemItem> filtered = _selectedKeyword == '전체'
        ? _items
        : _items.where((_ProblemItem item) => item.keywords.contains(_selectedKeyword)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('라이브러리'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/'),
        ),
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
                case 'account':
                  context.go('/account');
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
              PopupMenuItem<String>(
                value: 'login',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.login_rounded),
                  title: Text('로그인'),
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
            ],
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFF8FAFC), Color(0xFFE0F2FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '키워드로 문제 분류',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Text('원하는 키워드를 눌러 관련 문제만 빠르게 확인하세요.'),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allKeywords
                    .map(
                      (String keyword) => KeywordFilterChip(
                        label: keyword,
                        selected: _selectedKeyword == keyword,
                        onSelected: (_) => setState(() => _selectedKeyword = keyword),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('선택한 키워드에 해당하는 문제가 없습니다'))
                    : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (BuildContext context, int index) {
                          final _ProblemItem item = filtered[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(999),
                                          color: const Color(0xFFE0F2FE),
                                        ),
                                        child: Text(
                                          item.subject,
                                          style: const TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(Icons.chevron_right),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    item.title,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: item.keywords
                                        .map(
                                          (String k) => Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(999),
                                              color: const Color(0xFFF1F5F9),
                                            ),
                                            child: Text(
                                              '#$k',
                                              style: const TextStyle(fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProblemItem {
  const _ProblemItem({required this.title, required this.subject, required this.keywords});

  final String title;
  final String subject;
  final List<String> keywords;
}
