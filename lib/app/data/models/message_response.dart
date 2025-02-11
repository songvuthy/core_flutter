class MessageResponse {
  final String message;
  final int? statusCode;

  MessageResponse({required this.message, required this.statusCode});

  factory MessageResponse.fromMap(Map<String, dynamic> json) =>
      MessageResponse(message: json["message"], statusCode: json["statusCode"]);
}
