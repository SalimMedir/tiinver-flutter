class BaseUrls {
  static const String apiBaseUrl = 'https://tiinver.com/api/v1';
  static const String supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: '');

  static String get proxyBaseUrl {
    if (supabaseUrl.isEmpty) {
      return apiBaseUrl;
    }
    return '${supabaseUrl.replaceAll(RegExp(r'/+$'), '')}/functions/v1/tiinver-proxy';
  }

  static String throughProxy(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return '${proxyBaseUrl}$normalizedPath';
  }
}
