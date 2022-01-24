part of 'api_exception.dart';

extension _DescribableIterable on Iterable<String> {
  Iterator<String> get describableIterator => _DescribableIterator(this);
}

class _DescribableIterator extends Iterator<String> {
  _DescribableIterator(Iterable<String> iterable)
      : _description = iterable.toList().toString(),
        _internal = iterable.iterator;

  final Iterator<String> _internal;

  final String _description;

  @override
  String toString() => _description;

  @override
  String get current => _internal.current;

  @override
  bool moveNext() => _internal.moveNext();
}
