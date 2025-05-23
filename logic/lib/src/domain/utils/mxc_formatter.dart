import 'dart:math';
import 'package:intl/intl.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'package:intl/intl.dart' as intl;

class MXCFormatter {
  static String formatBigNumber(double number) {
    if (number >= 1000000000) {
      // Convert to millions
      double num = number / 1000000000.0;
      return '${num.toStringAsFixed(num.truncateToDouble() == num ? 0 : Config.decimalShowFixed)}B';
    } else if (number >= 1000000) {
      // Convert to millions
      double num = number / 1000000.0;
      return '${num.toStringAsFixed(num.truncateToDouble() == num ? 0 : Config.decimalShowFixed)}M';
    } else if (number >= 1000) {
      // Convert to thousands
      double num = number / 1000.0;
      return '${num.toStringAsFixed(num.truncateToDouble() == num ? 0 : Config.decimalShowFixed)}K';
    } else {
      int accuracy = number.toString().split('.').last.length;
      var str = number.toString();
      if (str.endsWith('.0')) {
        return str.substring(0, str.length - 2);
      }
      return number.toStringAsFixed(accuracy);
    }
  }

  static String intThousandsSeparator(String inputString) {
    return intl.NumberFormat('#,##0').format(int.parse(inputString));
  }

  static String formatWalletAddress(String inputString, {int? nCharacters}) {
    if (!RegExp(r'^(0x)?[0-9a-f]{40}', caseSensitive: false)
        .hasMatch(inputString)) return inputString;

    if (inputString.isEmpty) return inputString;

    String formattedString =
        '${inputString.substring(0, nCharacters ?? 4)}...${inputString.substring(inputString.length - 4)}';
    return formattedString;
  }

  // Example 984766546546546546546548494313898765 => 98476..98765
  static String formatLongText(String inputString, {int? nCharacters}) {
    if (inputString.isEmpty) return inputString;
    // Handle if text is short
    if (nCharacters != null) if (inputString.length <= (nCharacters * 2)) return inputString;

    String formattedString =
        '${inputString.substring(0, nCharacters ?? 4)}...${inputString.substring(inputString.length - (nCharacters ?? 4))}';
    return formattedString;
  }

  static String convertWeiToEth(String inputString, int tokenDecimal) {
    // 10^18 = 1000000000000000000 but we want to have up to 2 digits accuracy
    if (double.parse(inputString).toDouble() < 1000000000000000) {
      return '0';
    }
    final valueDouble = double.parse(inputString).toDouble() / pow(10, 18);
    String convertedString = valueDouble % 1 == 0
        ? valueDouble.toString()
        : valueDouble.toStringAsFixed(Config.decimalShowFixed);
    return convertedString;
  }

  /// The input is in wei the output is in Eth
  static String formatNumberForUI(
    String input,
  ) {
    String fractionalPart = '';
    String integerPart = input;
    if (input.contains('.')) {
      final spitedString = input.split('.');
      integerPart = spitedString[0];
      fractionalPart =
          '.${spitedString[1].substring(0, spitedString[1].length > Config.decimalShowFixed ? Config.decimalShowFixed : spitedString[1].length)}';
    }
    integerPart = intThousandsSeparator(integerPart);
    return '$integerPart$fractionalPart';
  }

  // Will read the double from thousand separated String
  // To be more specific the return String of formatNumberForUI
  static double readDoubleFromFormattedString(String input) {
    final format = NumberFormat.decimalPattern();
    return format.parse(input).toDouble();
  }

  static String localTime(DateTime time) {
    final localTime = time.toLocal();
    final month = localTime.month.toString().padLeft(2, '0');
    final day = localTime.day.toString().padLeft(2, '0');
    final year = localTime.year.toString().substring(2, 4);
    final hour = localTime.hour.toString().padLeft(2, '0');
    final minute = localTime.minute.toString().padLeft(2, '0');
    return '$month-$day-$year $hour:$minute';
  }

  static int hexToDecimal(String value) {
    try {
      if (value.isEmpty) return -1;
      return int.parse(value);
    } catch (e) {
      throw e.toString();
    }
  }

  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// returns the same value If It's empty or invalid double
  static String formatToStandardDecimals(String value) {
    if (value.isEmpty) return value;

    if (!MXCValidation.isDouble(value)) return value;

    final splitValue = value.split('.');
    return '${splitValue[0]}.${splitValue[1].substring(0, 8)}';
  }

  static Uri mergeUrl(String first, String second) {
    return Uri.parse(first).resolve(second);
  }

  static String mergeUrlString(String first, String second) {
    return Uri.parse(first).resolve(second).toString();
  }

  // Function to trim and remove extra spaces
  static String trimAndRemoveExtraSpaces(String value) {
    if (value.isEmpty) return '';
    // Remove all new lines spaces
    String trimmedValue = value.replaceAll('\n', '');
    // String trimmedValue = value.trim();
    List<String> words = trimmedValue.split(' '); // Split into individual words

    // Remove extra spaces and new lines between words
    words = words.where((word) => word.isNotEmpty).toList();

    return words.join(' '); // Join words back with a single space between each
  }

  static String removeZeroX(String value) {
    return value.startsWith('0x') ? value.substring(2) : value;
  }

  static String escapeDoubleQuotes(String value) {
    return value.replaceAll('"', '\\"');
  }

  static String checkExpoNumber(String value) {
    return MXCValidation.isExpoNumber(value) ? '0.000' : value;
  }

  static String formatExpoNumber(double number) {
    NumberFormat formatter = NumberFormat('###', 'en_US');
    return formatter.format(number);
  }
}
