import 'package:flutter_test/flutter_test.dart';
import 'package:dash_shop/utils/formatters.dart';

void main() {
  group('CardNumberFormatter', () {
    final formatter = CardNumberFormatter();

    test('adds spaces every 4 digits', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '12345');
      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '1234 5');
    });

    test('limits to 16 digits', () {
      const oldValue = TextEditingValue(text: '1234 1234 1234 1234');
      const newValue = TextEditingValue(text: '1234 1234 1234 12345');
      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '1234 1234 1234 1234');
    });
  });

  group('ExpirationDateFormatter', () {
    final formatter = ExpirationDateFormatter();

    test('adds slash after 2 digits', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '123');
      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '12/3');
    });

    test('limits to 4 digits', () {
      const oldValue = TextEditingValue(text: '12/34');
      const newValue = TextEditingValue(text: '12/345');
      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '12/34');
    });
  });

  group('PhoneNumberFormatter', () {
    final formatter = PhoneNumberFormatter();

    test('formats phone number correctly', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '1234567890');
      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '(123) 456-7890');
    });

    test('no trailing delimiters', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '123');
      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '(123'); // No trailing ") "
    });

    test('backspace after hyphen allows deletion', () {
      // User typed 7 digits, got (123) 456-7
      const oldValue = TextEditingValue(text: '(123) 456-7');
      // User backspaces the '7'
      const newValue = TextEditingValue(text: '(123) 456-');
      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '(123) 456'); // Delimiter is automatically removed
    });
  });
}
