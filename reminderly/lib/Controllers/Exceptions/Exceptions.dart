class AppException implements Exception {
  final String message;
  final String prefix;
  final String url;

  AppException([this.message, this.prefix, this.url]);
}

class BadRequestException extends AppException {
  BadRequestException([String message, String url])
      : super(message, 'Bad Request', url);
}

class FetchDataException extends AppException {
  FetchDataException([String message, String url])
      : super(message, 'Unable to process', url);
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException([String message, String url])
      : super(message, 'Api not responded in time', url);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([String message, String url])
      : super(message, 'UnAuthorized request', url);
}

class UserAlreadyExists extends AppException {
  UserAlreadyExists([String message, String url])
      : super(message, 'User Already Exists with this Email.', url);
}

class InternalServerError extends AppException {
  InternalServerError([String message, String url])
      : super(message, 'Internal Server Error.', url);
}

class UnAuthenticatedException extends AppException {
  UnAuthenticatedException([String message, String url])
      : super(message, 'You are Logged out.', url);
}
