enum UiExceptionType { warning, error }

class UiException {
  final String message;
  final UiExceptionType type;
  const UiException(this.message, this.type);
}
