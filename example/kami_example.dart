import 'package:dio/dio.dart';
import 'package:kami/kami.dart';
import 'package:meta/meta.dart';

class ApiExceptionParser extends ApiExceptionParserBase {
  ApiExceptionParser._() : super();
  static ApiExceptionParser instance = ApiExceptionParser._();

  @override
  ApiExceptionBaseInitializer builder() => _ApiException.instance;
}

abstract class ApiException extends ApiExceptionBase {
  const ApiException.inherit();
  factory ApiException() => _ApiException.instance;
}

class _ApiException extends ApiException with ApiExceptionMixin implements ApiExceptionBaseInitializer {
  _ApiException._() : super.inherit();
  static _ApiException instance = _ApiException._();

  @override
  init() {
    register('AUTH', ApiAuthException().fromCodeSequence);
    ApiAuthException().init();
  }
}

abstract class ApiAuthException extends ApiException {
  const ApiAuthException.inherit() : super.inherit();
  factory ApiAuthException() => _ApiAuthExceptionBase.instance;

  static TypeWrapper<ApiAuthException> someAuthError =
  TypeWrapper<_SomeAuthError>();
}

class _ApiAuthExceptionBase extends ApiAuthException with ApiExceptionMixin<ApiAuthException> {
  _ApiAuthExceptionBase._() : super.inherit();
  static ApiAuthException instance = _ApiAuthExceptionBase._();

  @override
  init() {
    register('SOME_AUTH_ERROR', _SomeAuthError._);
  }
}

@sealed
class _SomeAuthError extends ApiAuthException with ApiExceptionLeaf {
  _SomeAuthError._(DioError error, [_]) : super.inherit() {
    this.error = error;
  }

  @override
  String get message => 'Something went wrong with an Auth request.';
}

void main() {

}