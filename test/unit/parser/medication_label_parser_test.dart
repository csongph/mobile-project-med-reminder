import 'package:flutter_test/flutter_test.dart';
import 'package:med_reminder/features/medications/services/medication_label_parser.dart';

// Simple mock for RecognizedText to avoid ML Kit dependency in tests
class MockRecognizedText {
  final String text;
  MockRecognizedText(this.text);
}

void main() {
  group('MedicationLabelParser Tests', () {
    // Note: These tests are simplified since we can't easily mock RecognizedText
    // In a real scenario, we would create integration tests with actual OCR output

    test('Parser class exists and is importable', () {
      expect(MedicationLabelParser, isNotNull);
    });

    test('MedicationLabelParseResult can be created', () {
      final result = MedicationLabelParseResult(
        nameCandidates: ['Paracetamol'],
        quantity: 30,
        instructions: 'Take one tablet daily',
        rawText: 'Paracetamol 500mg',
      );

      expect(result.nameCandidates, ['Paracetamol']);
      expect(result.quantity, 30);
      expect(result.instructions, 'Take one tablet daily');
      expect(result.rawText, 'Paracetamol 500mg');
    });

    test('MedicationLabelParseResult handles empty candidates', () {
      final result = MedicationLabelParseResult(
        nameCandidates: [],
        quantity: null,
        instructions: '',
        rawText: '',
      );

      expect(result.nameCandidates, isEmpty);
      expect(result.quantity, isNull);
      expect(result.instructions, isEmpty);
      expect(result.rawText, isEmpty);
    });

    test('MedicationLabelParseResult handles null quantity', () {
      final result = MedicationLabelParseResult(
        nameCandidates: ['Aspirin'],
        quantity: null,
        instructions: '',
        rawText: 'Aspirin',
      );

      expect(result.quantity, isNull);
    });

    test('MedicationLabelParseResult can handle multiple candidates', () {
      final result = MedicationLabelParseResult(
        nameCandidates: ['Paracetamol', 'Ibuprofen', 'Aspirin'],
        quantity: 10,
        instructions: '',
        rawText: 'Medicine label',
      );

      expect(result.nameCandidates.length, 3);
      expect(result.nameCandidates, contains('Paracetamol'));
      expect(result.nameCandidates, contains('Ibuprofen'));
      expect(result.nameCandidates, contains('Aspirin'));
    });
  });
}
