class InputValidator {
  static bool isPhoneNumberValid(String phoneNumber) {
    RegExp phoneNumberRegex = RegExp(
        r'^([+][254]{3}|0)(|-)(7[0-9]|1[0-1])[0-9](|-)([0-9]){3}(|-)([0-9]){3}$');
    return phoneNumberRegex.hasMatch(phoneNumber);
  }

  static bool isEmailValid(String email) {
    RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  static bool passwordValidator(String password) {
    if (password.length < 8) {
      return false;
    }
    return true;
  }
}
