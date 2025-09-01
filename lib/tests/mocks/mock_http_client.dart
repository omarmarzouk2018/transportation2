// Simplified mock for tests (non-production)
import 'package:http/http.dart' as http;

class MockHttpClient {
  final Map<String, http.Response> _responses = {};

  void registerResponse(Uri uri, String json, int statusCode) {
    _responses[uri.toString()] = http.Response(json, statusCode);
  }

  http.Response? getResponse(Uri uri) {
    return _responses[uri.toString()];
  }

  void reset() {
    _responses.clear();
  }
}
