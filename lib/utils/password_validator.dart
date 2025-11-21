class PasswordValidator {
  // Validates password strength based on PHP securePW function
  // Rules:
  // - At least 8 characters
  // - Contains at least one lowercase letter
  // - Contains at least one uppercase letter
  // - Contains at least one digit
  // - Contains at least one special character (@$!%*?&_)
  static bool isPasswordSecure(String password) {
    if (password == null || password.isEmpty) {
      return false;
    }

    // At least 8 characters
    if (password.length < 8) {
      return false;
    }

    // Contains at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return false;
    }

    // Contains at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return false;
    }

    // Contains at least one digit
    if (!RegExp(r'\d').hasMatch(password)) {
      return false;
    }

    // Contains at least one special character (@$!%*?&_)
    if (!RegExp(r'[@$!%*?&_]').hasMatch(password)) {
      return false;
    }

    return true;
  }

  // Checks if password is weak based on user_key from information API
  // user_key is the plain text password, so we can directly validate it
  static bool isPasswordWeakFromAccount(Map<String, dynamic> account) {
    if (account == null) {
      return false;
    }

    // First, check if API provides password_strength flag
    if (account.containsKey("password_strength")) {
      String passwordStrength = account["password_strength"]?.toString() ?? "";
      if (passwordStrength == "weak" || passwordStrength == "0" || passwordStrength == "false") {
        return true;
      }
      if (passwordStrength == "strong" || passwordStrength == "1" || passwordStrength == "true") {
        return false;
      }
    }

    // user_key is the plain text password, so we can directly validate it
    String userKey = account["user_key"]?.toString() ?? "";
    
    if (userKey.isEmpty || userKey == "null") {
      return false; // Can't determine, assume not weak
    }

    // Directly validate the password using the secure password rules
    // This matches the PHP securePW function
    bool isSecure = isPasswordSecure(userKey);
    
    // Return true if password is NOT secure (i.e., it's weak)
    return !isSecure;
  }
}

