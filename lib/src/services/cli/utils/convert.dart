class Convertor {
  static String snakeToCamel(String input) {
    List<String> parts = input.split('_');

    // Capitalize the first letter of each part (except the first one)
    for (int i = 0; i < parts.length; i++) {
      parts[i] = parts[i][0].toUpperCase() + parts[i].substring(1);
    }

    // Join the parts to form the camelCase string
    return parts.join('');
  }

  static String camelToSnake(String input) {
    StringBuffer result = StringBuffer();

    for (int i = 0; i < input.length; i++) {
      String currentChar = input[i];

      // Check if the current character is uppercase
      if (currentChar == currentChar.toUpperCase()) {
        // Add an underscore before the uppercase letter
        result.write('_');
      }

      // Convert the character to lowercase and append to the result
      result.write(currentChar.toLowerCase());
    }

    return result.toString();
  }
}
