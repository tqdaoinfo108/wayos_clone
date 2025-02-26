import 'dart:async';

import 'package:http/http.dart' as http;

/// Http client holding a username and password to be used for Basic authentication
class BasicAuthClient extends http.BaseClient {
  final String token;

  final http.Client _inner;
  final String _authString;

  /// Creates a client wrapping [inner] that uses Basic HTTP auth.
  ///
  /// Constructs a new [BasicAuthClient] which will use the provided [username]
  /// and [password] for all subsequent requests.
  BasicAuthClient(this.token, {http.Client? inner})
      : _authString = token,
        _inner = inner ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers['Authorization'] = _authString;
    request.headers['Content-Type'] = "application/json";

        
    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
  }
}
