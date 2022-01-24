import 'package:dio/dio.dart';
import 'package:kami/src/kami_exception.dart';
import 'package:meta/meta.dart';

part '_errors.dart';
part '_internal.dart';

typedef ApiExceptionBuilder<T extends ApiExceptionBase> = T Function(
    DioError error, Iterator<String> codeSequence);

abstract class ApiExceptionParserBase {
  ApiExceptionParserBase() {
    final base = builder();
    if (!base.hasBuilders) base.init();
    assert(base.hasBuilders, 'Must register builders in $runtimeType.init');
  }

  ApiExceptionBaseInitializer builder();

  ApiExceptionBase fromDioError(DioError error) {
    return builder()
        .fromCodeSequence(error, _getSequence(error).describableIterator);
  }

  static List<String> _getSequence(DioError error) =>
      error.response!.data['error'].split(':');
}

abstract class ApiExceptionBase extends KamiException {
  const ApiExceptionBase();

  @nonVirtual
  DioError get error =>
      throw "Declare class $runtimeType with ApiExceptionLeaf<$runtimeType>";

  @protected
  init() => throw "init getter must be overridden in class $runtimeType";

  bool get hasBuilders => true;

  ApiExceptionBase fromCodeSequence(
          DioError error, Iterator<String> codeSequence) =>
      throw "Declare class $runtimeType with ApiExceptionMixin<$runtimeType>";
}

mixin ApiExceptionMixin<T extends ApiExceptionBase> on ApiExceptionBase {
  @override
  String get message =>
      throw "message getter must be overridden in class $runtimeType";

  final Map<String, ApiExceptionBuilder> _builders = {};

  @override
  bool get hasBuilders => _builders.isNotEmpty;

  @override
  ApiExceptionBase fromCodeSequence(
      DioError error, Iterator<String> codeSequence) {
    final code = (codeSequence..moveNext()).current;
    final builder = _builders[code];
    if (builder == null) {
      throw ApiExceptionError.UnregisteredCode(code);
    }
    return builder(error, codeSequence);
  }

  @protected
  void register(String code, ApiExceptionBuilder builder) {
    assert(builder is ApiExceptionBuilder<T>,
        ApiExceptionError.BadBuilderTypeError(T).toString());
    assert(!_builders.containsKey(code),
        ApiExceptionError.BuilderExists(code).toString());
    _builders[code] = builder;
  }
}

mixin ApiExceptionBaseInitializer implements ApiExceptionBase, ApiExceptionMixin {
}

mixin ApiExceptionLeaf on ApiExceptionBase {
  DioError? _error;

  @override
  // ignore: invalid_override_of_non_virtual_member
  DioError get error {
    assert(_error != null, "Framework Error: this should not happen.");
    return _error!;
  }

  @protected
  set error(DioError error) {
    assert(_error == null,
        "You should NOT be setting error from outside an ApiException derived constructor!!!");
    _error = error;
  }

  @protected
  @alwaysThrows
  ApiExceptionBase fromDioError(DioError error) =>
      throw "fromDioError is not callable on an ApiExceptionLeaf";
}

class TypeWrapper<T> {
  bool hasInstanceOf(instance) => instance is T;
}
