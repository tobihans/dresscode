extension ListExtensions<T> on List<T>? {
  /// Return the first element of a collection
  /// If the collection is empty, return a default value
  T firstOrDefault(T defaultValue) {
    return this?.firstWhere((element) => true, orElse: () => defaultValue) ??
        defaultValue;
  }

  /// Apply a function on the first element of a collection
  /// Else, apply the function to the default element chosen
  U firstOrDefaultAndApply<U>(T defaultValue, U Function(T) action) {
    return action(firstOrDefault(defaultValue));
  }
}
