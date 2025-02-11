class TokenResponse {
  final Token data;
  TokenResponse({
    required this.data,
  });

  factory TokenResponse.fromMap(Map<String, dynamic> map) {
    return TokenResponse(
      data: Token.fromMap(map['data'] as Map<String, dynamic>),
    );
  }
}

class Token {
  final String accessToken;
  final String refreshToken;

  Token({
    required this.accessToken,
    required this.refreshToken,
  });
  factory Token.fromMap(Map<String, dynamic> map) {
    return Token(
      accessToken: map['accessToken'] as String,
      refreshToken: map['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
