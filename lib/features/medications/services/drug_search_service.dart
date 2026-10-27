import 'dart:convert';

import 'package:http/http.dart' as http;

class DrugSearchResult {
  final String name;
  final String? rxcui;

  const DrugSearchResult({required this.name, this.rxcui});
}

/// Searches the public RxNorm vocabulary for normalized medicine names.
/// Results are suggestions only; the user must select and verify one.
class DrugSearchService {
  static const _endpoint =
      'https://rxnav.nlm.nih.gov/REST/approximateTerm.json';

  Future<List<DrugSearchResult>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) return const [];

    final uri = Uri.parse(
      _endpoint,
    ).replace(queryParameters: {'term': trimmed, 'maxEntries': '8'});
    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) return const [];

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates =
        (json['approximateGroup'] as Map<String, dynamic>?)?['candidate']
            as List?;
    if (candidates == null) return const [];

    return candidates
        .whereType<Map>()
        .map(
          (item) => DrugSearchResult(
            name: item['name'] as String? ?? '',
            rxcui: item['rxcui']?.toString(),
          ),
        )
        .where((item) => item.name.isNotEmpty)
        .toList();
  }
}
