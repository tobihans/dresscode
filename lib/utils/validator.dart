class Validator {
  static const _infinityIsInt = double.infinity is int;
  static const _maxInt = _infinityIsInt ? double.infinity as int : ~_minInt;
  static const _minInt = _infinityIsInt ? -double.infinity as int : (-1 << 63);
  static const _emailRegex =
      r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
  static const _pwdRegex = r"(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[^a-zA-Z]).{6,}";

  static String? validateNotNull<T>(String name, T? value) {
    if (value == null) {
      return 'Le champ $name est requis';
    }
    return null;
  }

  static String? validateNotEmpty(String name, String? value) {
    if (value?.trim().isEmpty ?? true) {
      return 'Le champ $name ne peut pas être vide';
    }
    return null;
  }

  static String? validateLength(String name, String? value,
      {int min = 0, int max = _maxInt}) {
    assert(min <= max);
    final len = value?.length ?? 0;
    if (min > len || max < len) {
      if (max < len) {
        return 'La taille du champ $name doit être inférieure à $max caractères';
      }
      if (min > len) {
        return 'La taille du champ $name doit être supérieure à $min caractères';
      }
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (!RegExp(_emailRegex).hasMatch(value ?? '')) {
      return '$value n\'est pas une addresse mail valide';
    }
    return null;
  }

  static String? validateSameValue<T>(
      String name1, String name2, T? value1, T? value2) {
    if (value1 != value2) {
      return 'Les champs $name1 et $name2 doivent avoir la même valeur';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (!RegExp(_pwdRegex).hasMatch(value ?? '')) {
      return 'Le mot de passe doit contenir au moins une lettre minuscule, une lettre majuscule, un chiffre et faire au moins 6 caractères';
    }
    return null;
  }
}
