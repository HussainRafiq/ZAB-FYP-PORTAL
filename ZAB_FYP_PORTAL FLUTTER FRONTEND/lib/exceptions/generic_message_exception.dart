class GenericMessageException implements Exception {
  final String Code;
  final String Message;

  GenericMessageException(this.Code, this.Message);
}
