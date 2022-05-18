typedef ValidatorFunc = String? Function(String? value);
typedef GenericValidatorFunc = String? Function<T>(T? value);

class Validator {
  static const _infinityIsInt = double.infinity is int;
  static const _maxInt = _infinityIsInt ? double.infinity as int : ~_minInt;
  static const _minInt = _infinityIsInt ? -double.infinity as int : (-1 << 63);
  static const _emailRegex = r"[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+";
  static const _pwdRegex = r"(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[^a-zA-Z]).{6,}";
  static const _phoneRegex = r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$";

  static GenericValidatorFunc validateNotNull(String name) {
    return <T>(T? value) {
      if (value == null) {
        return 'Le champ $name est requis';
      }
      return null;
    };
  }

  static ValidatorFunc validateNotEmpty(String name) {
    return (String? value) {
      if (value?.trim().isEmpty ?? true) {
        return 'Le champ $name ne peut pas être vide';
      }
      return null;
    };
  }

  static ValidatorFunc validateSpaceInString(String name) {
    return (String? value) {
      if (value?.split(' ').isEmpty ?? true) {
        return 'Le champ $name doit contenir au moins un espace';
      }
      return null;
    };
  }

  static ValidatorFunc validateLength(String name,
      {int min = 0, int max = _maxInt}) {
    return (String? value) {
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
    };
  }

  static ValidatorFunc validateEmail() {
    return (String? value) {
      if (!RegExp(_emailRegex).hasMatch(value ?? '')) {
        return '"$value" n\'est pas une addresse mail valide';
      }
      return null;
    };
  }

  static ValidatorFunc validatePhone() {
    return (String? value) {
      if (!RegExp(_phoneRegex).hasMatch(value ?? '')) {
        return '"$value" n\'est pas un numéro valide';
      }
      return null;
    };
  }

  static String? Function(T? value) validateSameValue<T>(
      String name1, String name2, T? value1) {
    return (T? value2) {
      if (value1 != value2) {
        return 'Les champs $name1 et $name2 doivent avoir la même valeur';
      }
      return null;
    };
  }

  static ValidatorFunc validatePassword() {
    return (String? value) {
      if (!RegExp(_pwdRegex).hasMatch(value ?? '')) {
        return '6 caractères dont une minuscule, une majuscule et un chiffre.';
      }
      return null;
    };
  }
}
