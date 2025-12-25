import 'package:flutter/material.dart';
import '../../data/services/dictionary_api_service.dart';

void showWordMeaningSheet(BuildContext context, String word) {
  final api = DictionaryApiService();

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return FutureBuilder<String>(
        future: api.fetchMeaning(word),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Center(child: CircularProgressIndicator())
                else
                  Text(
                    snapshot.data ?? 'No meaning available.',
                    style: const TextStyle(fontSize: 14),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}
