import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odab_ddokddok/features/auth/application/auth_service.dart';

final StateProvider<bool> authLoggedInProvider = StateProvider<bool>((ref) => false);

final Provider<AuthService> authServiceProvider = Provider<AuthService>((ref) {
	return AuthService();
});
