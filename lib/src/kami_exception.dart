import 'package:meta/meta.dart';

abstract class KamiException implements Exception {
  const KamiException();

  String get message;

  @override
  @nonVirtual
  String toString() {
    Object? message = this.message;
    return '$prefix: $message';
  }

  @mustCallSuper
  String? get prefix => '';
}

