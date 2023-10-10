extension ListExtensions<E> on List<E> {
  E? removeLastSafe() {
    if (isEmpty) {
      return null;
    } else {
      return removeLast();
    }
  }

  E? firstWhereSafe(bool Function(E element) test) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }
}
