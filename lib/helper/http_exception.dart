class HttpException implements Exception {
  final Map<String, dynamic> message;
  HttpException(this.message);
  @override
  String toString() {
    return message.toString();
  }
}

class HttpExpectionString implements Exception {
  final String message;
  HttpExpectionString(this.message);
  @override
  String toString() {
    return message;
  }
}
