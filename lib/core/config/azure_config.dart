/// Azure Table Storage 설정
class AzureConfig {
  /// Azure Storage 계정 이름
  /// 예: odabddokddok
  static const String storageAccountName = String.fromEnvironment(
    'AZURE_STORAGE_ACCOUNT_NAME',
    defaultValue: 'odabddokddok',
  );

  /// Azure Storage 계정 키
  /// Azure Portal > Storage Account > Access Keys에서 복사
  static const String storageAccountKey = String.fromEnvironment(
    'AZURE_STORAGE_ACCOUNT_KEY',
    defaultValue: '',
  );

  /// Table Storage 테이블 이름
  static const String usersTableName = 'Users';
  static const String problemsTableName = 'Problems';

  /// Azure Storage 엔드포인트
  static String get tableServiceEndpoint =>
      'https://$storageAccountName.table.core.windows.net';

  /// 요청 타임아웃 (초)
  static const int requestTimeoutSeconds = 30;
}

