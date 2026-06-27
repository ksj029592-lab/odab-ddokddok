import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odab_ddokddok/features/auth/application/auth_service.dart';
import 'package:odab_ddokddok/features/auth/application/azure_table_storage_auth_service.dart';

final StateProvider<bool> authLoggedInProvider = StateProvider<bool>((ref) => false);

/// 로컬 스토리지 사용 (기존 방식)
final Provider<AuthService> authServiceProvider = Provider<AuthService>((ref) {
	return AuthService();
});

/// Azure Table Storage 사용 (권장)
final Provider<AzureTableStorageAuthService> azureTableStorageAuthServiceProvider =
    Provider<AzureTableStorageAuthService>((ref) {
	return AzureTableStorageAuthService();
});
