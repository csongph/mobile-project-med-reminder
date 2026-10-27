import 'dart:math' as math;

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Conservative parsing for medicine labels. OCR is noisy, so suggestions are
/// shown for the user to confirm instead of silently saving a guessed name.
class MedicationLabelParser {
  static final _strength = RegExp(
    r'\b\d+(?:[.,]\d+)?\s*(?:mg|mcg|μg|g|ml|mL|iu|units?|%)\b',
    caseSensitive: false,
  );
  static final _quantity = RegExp(
    r'(?:\b(?:qty|quantity|pack\s+of|contains|total)\s*[:#-]?\s*(\d{1,4})\b)|(?:\b(\d{1,4})\s*(?:tablets?|tabs?|capsules?|caps?|caplets?|เม็ด|แคปซูล)\b)',
    caseSensitive: false,
  );
  static final _excluded = RegExp(
    r'\b(?:composition|ingredients?|dosage|directions?|indications?|warnings?|caution|storage|store|keep|expiry|expires|exp\.?|mfg\.?|manufactured|batch|lot\s*(?:no|number)?|registration|reg\.?\s*no|prescription|pharma(?:ceutical)?s?|laborator(?:y|ies)|distributed|manufacturer|each\s+tablet|oral\s+use|for\s+external\s+use|take\s+one|take\s+with|made\s+in)\b',
    caseSensitive: false,
  );
  static final _instruction = RegExp(
    r'\b(?:take\s+\d|take\s+one|once\s+daily|twice\s+daily|before\s+meals?|after\s+meals?|with\s+food|as\s+directed|store\s+below|keep\s+out\s+of|shake\s+well|do\s+not\s+exceed)\b',
    caseSensitive: false,
  );

  static MedicationLabelParseResult parse(RecognizedText recognized) {
    final lines = <_LabelLine>[];
    for (final block in recognized.blocks) {
      for (final line in block.lines) {
        final text = line.text.trim();
        if (text.isNotEmpty) {
          lines.add(
            _LabelLine(text, line.boundingBox.top, line.boundingBox.height),
          );
        }
      }
    }
    if (lines.isEmpty) {
      lines.addAll(
        recognized.text
            .split('\n')
            .map((text) => text.trim())
            .where((text) => text.isNotEmpty)
            .map((text) => _LabelLine(text, lines.length.toDouble(), 1)),
      );
    }

    final heights =
        lines.map((line) => line.height).where((height) => height > 0).toList()
          ..sort();
    final medianHeight = heights.isEmpty ? 1.0 : heights[heights.length ~/ 2];
    final scores = <String, double>{};
    final originalOrder = <String, int>{};

    for (var index = 0; index < lines.length; index++) {
      final line = lines[index];
      final text = _cleanCandidate(line.text);
      if (!_isPlausibleName(text)) continue;

      final letters = RegExp(r'[A-Za-z]').allMatches(text).length;
      final words = text
          .split(RegExp(r'\s+'))
          .where((word) => word.isNotEmpty)
          .length;
      var score = 1.0 + math.min(letters, 24) / 12;
      if (_strength.hasMatch(text)) score += 1.5;
      if (RegExp(
        r'^[A-Z][A-Za-z0-9-]*(?:\s+[A-Z][A-Za-z0-9-]*)*$',
      ).hasMatch(text)) {
        score += 0.45;
      }
      if (words >= 2 && words <= 5) score += 0.35;
      if (index < 4) score += 0.25;
      if (medianHeight > 0) {
        score += ((line.height / medianHeight) - 1).clamp(-0.5, 1.5) * 0.55;
      }
      final key = text.toLowerCase();
      if (!scores.containsKey(key) || score > scores[key]!) {
        scores[key] = score;
        originalOrder[key] = index;
      }
    }

    final ranked = scores.keys.toList()
      ..sort((a, b) {
        final byScore = scores[b]!.compareTo(scores[a]!);
        return byScore != 0
            ? byScore
            : originalOrder[a]!.compareTo(originalOrder[b]!);
      });
    final candidates = ranked.take(4).map((key) => key).toList();

    int? quantity;
    for (final line in lines) {
      final match = _quantity.firstMatch(line.text);
      final rawCount = match?.group(1) ?? match?.group(2);
      final parsed = int.tryParse(rawCount ?? '');
      if (parsed != null && parsed > 0 && parsed <= 9999) {
        quantity = parsed;
        break;
      }
    }

    final instructions = lines
        .map((line) => line.text.trim())
        .where((line) => _instruction.hasMatch(line))
        .toSet()
        .join('\n');

    return MedicationLabelParseResult(
      nameCandidates: candidates,
      quantity: quantity,
      instructions: instructions,
      rawText: recognized.text.trim(),
    );
  }

  static bool _isPlausibleName(String text) {
    if (text.length < 3 || text.length > 52 || _excluded.hasMatch(text)) {
      return false;
    }
    if (RegExp(r'^\d[\d\s./:-]*$').hasMatch(text)) return false;
    if (RegExp(
      r'^\d+(?:[.,]\d+)?\s*(?:mg|mcg|μg|g|ml|iu|units?|%)$',
      caseSensitive: false,
    ).hasMatch(text)) {
      return false;
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(text)) return false;
    final words = text
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
    return words <= 7;
  }

  static String _cleanCandidate(String text) => text
      .replaceAll(RegExp(r'^[^A-Za-z0-9]+|[^A-Za-z0-9%]+$'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

class MedicationLabelParseResult {
  final List<String> nameCandidates;
  final int? quantity;
  final String instructions;
  final String rawText;

  const MedicationLabelParseResult({
    required this.nameCandidates,
    required this.quantity,
    required this.instructions,
    required this.rawText,
  });
}

class _LabelLine {
  final String text;
  final double top;
  final double height;

  const _LabelLine(this.text, this.top, this.height);
}
