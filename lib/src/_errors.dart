part of 'api_exception.dart';

abstract class ApiExceptionError extends KamiException {
  const ApiExceptionError();

  // ignore: non_constant_identifier_names
  const factory ApiExceptionError.BadBuilderTypeError(Type T) = _BadBuilderTypeError;
  // ignore: non_constant_identifier_names
  const factory ApiExceptionError.UnregisteredCode(String code) = _UnregisteredCodeError;
  // ignore: non_constant_identifier_names
  const factory ApiExceptionError.BuilderExists(String code) = _BuilderExistsError;

  static bool isBuilderExistsError(ApiExceptionError exception) => exception is _BuilderExistsError;
  static bool isUnregisteredCodeError(ApiExceptionError exception) => exception is _UnregisteredCodeError;

  @override
  String get prefix => '${super.prefix}::ApiException';
}

class _BuilderExistsError extends ApiExceptionError {
  const _BuilderExistsError(this.code);

  final String code;

  @override
  String get message => "Cannot register builder for existing code '$code'";

  @override
  String get prefix => '${super.prefix}::BuilderExists';
}

class _UnregisteredCodeError extends ApiExceptionError {
  const _UnregisteredCodeError(this.code);

  final String code;

  @override
  String get message => "No builder registered for code '$code'";

  @override
  String get prefix => '${super.prefix}::UnregisteredCode';
}

class _BadBuilderTypeError extends ApiExceptionError {
  const _BadBuilderTypeError(this.T);

  final Type T;

  @override
  String get message => 'Can only register builders of type $T Function(DioError error, Iterator<String> codeSequence) on $T.init';

  @override
  String get prefix => '${super.prefix}::BadBuilderType';
}

