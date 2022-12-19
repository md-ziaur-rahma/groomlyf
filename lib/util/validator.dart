//sign in sign up validator

class Validator {
  static String? validateEmail(String? value) {
    Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = new RegExp(pattern as String);
    if (!regex.hasMatch(value!))
      return 'Please enter a valid email address.';
    else
      return null;
  }

  static String? validatePassword(String? value) {
    Pattern pattern = r'^.{6,}$';
    RegExp regex = new RegExp(pattern as String);
    if (!regex.hasMatch(value!))
      return 'Password must be at least 6 characters.';
    else
      return null;
  }

  static String? validateName(String? value) {
    Pattern pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
    RegExp regex = new RegExp(pattern as String);
    if (!regex.hasMatch(value!))
      return 'Please enter a name.';
    else
      return null;
  }

  static String? validatePrice(String? value) {
    if (value!.isEmpty)
      return 'Please enter aaverage price.';
    else
      return null;
  }

  static String? validateNumber(String value) {
    Pattern pattern = r'^\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})$';
    RegExp regex = new RegExp(pattern as String);
    if (!regex.hasMatch(value))
      return 'Please enter a number.';
    else
      return null;
  }

  static String? validateConfirmPassword(String value, String passwordField) {
    if (passwordField.isEmpty) {
      return 'Please enter a password.';
    }
    if (passwordField != value) {
      return 'Passwords don\'t match';
    }
    return null;
  }

  static String? Function(String?) validateString([String? error]) {
    return (String? value) {
      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return error ?? 'Field is required.';
      }
      return null;
    };
  }
}
