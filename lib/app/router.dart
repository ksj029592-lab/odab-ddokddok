import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:odab_ddokddok/features/account/presentation/screens/account_screen.dart';
import 'package:odab_ddokddok/features/auth/presentation/screens/login_screen.dart';
import 'package:odab_ddokddok/features/auth/presentation/screens/signup_screen.dart';
import 'package:odab_ddokddok/features/common/presentation/screens/feature_teaser_screen.dart';
import 'package:odab_ddokddok/features/home/presentation/screens/home_screen.dart';
import 'package:odab_ddokddok/features/library/presentation/screens/library_screen.dart';
import 'package:odab_ddokddok/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:odab_ddokddok/features/scan/presentation/scan_screen.dart';

/// Create the router configuration for the app
/// 
/// Routes:
/// - /: Home screen
/// - /onboarding: Onboarding flow
/// - /scan: Scan/register problem
/// - /library: Problem library
/// - /problem/:id: Problem detail
/// - /review: Review session
/// - /stats: Learning statistics
/// - /settings: App settings
GoRouter createRouter({String initialLocation = '/'}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      // Onboarding flow routes
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      // Scan route
      GoRoute(
        path: '/scan',
        name: 'scan',
        builder: (context, state) => const ScanScreen(),
      ),
      // Library route
      GoRoute(
        path: '/library',
        name: 'library',
        builder: (context, state) => const LibraryScreen(),
      ),
      // Problem detail route
      GoRoute(
        path: '/problem/:id',
        name: 'problem-detail',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return FeatureTeaserScreen(
            title: '문제 상세',
            subtitle: '문제 $id 화면을 준비중입니다',
            highlights: const <String>[
              '문제 이미지 + 정답/오답 기록',
              '복습 이력 타임라인',
              '개인 해설/노트 편집',
            ],
            accent: const Color(0xFF0EA5A4),
          );
        },
      ),
      // Review route
      GoRoute(
        path: '/review',
        name: 'review',
        builder: (context, state) => const FeatureTeaserScreen(
          title: '복습 세션',
          subtitle: '집중 복습 모드를 준비하고 있어요',
          highlights: <String>[
            'SM-2 기반 맞춤 복습 순서',
            '한 번에 여러 문제 빠른 채점',
            '세션 종료 후 성취 리포트',
          ],
          accent: Color(0xFFF97316),
        ),
      ),
      // Stats route
      GoRoute(
        path: '/stats',
        name: 'stats',
        builder: (context, state) => const FeatureTeaserScreen(
          title: '통계',
          subtitle: '학습 인사이트 대시보드를 준비하고 있어요',
          highlights: <String>[
            '오답 유형 히트맵',
            '주간 복습 완주율',
            '과목별 실력 성장 그래프',
          ],
          accent: Color(0xFF7C3AED),
        ),
      ),
      // Settings route
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const FeatureTeaserScreen(
          title: '설정',
          subtitle: '개인화 옵션을 준비하고 있어요',
          highlights: <String>[
            '알림 시간/빈도 커스터마이징',
            '테마 및 접근성 설정',
            '데이터 백업/복원',
          ],
          accent: Color(0xFF0F766E),
        ),
      ),
      GoRoute(
        path: '/account',
        name: 'account',
        builder: (context, state) => const AccountScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
    ],
  );
}
