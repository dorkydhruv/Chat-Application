import 'dart:collection';

class Token extends MapView<String, dynamic> {
  final String token;
  final String type;
  Token({
    required this.token,
    required this.type,
  }) : super({
          "access_token": token,
          "token_type": type,
        });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json["access_token"],
      type: json["token_type"],
    );
  }

  String get accessToken => "$type $token";
}
