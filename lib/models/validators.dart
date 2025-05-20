String? emailValidator(String? value) {
  RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  if (value == null || value.trim().isEmpty) {
    return "Please enter your E-mail address";
  }
  if (!emailRegex.hasMatch(value)) {
    return "Please enter a valid E-mail address";
  }
  return null;
}

String? requiredFieldValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Please enter your E-mail address";
  }
  return null;
}