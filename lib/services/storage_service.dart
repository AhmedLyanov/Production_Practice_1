import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word.dart';
import '../models/word_set.dart';

class StorageService {
  static const String _setsKey = 'word_sets';

  Future<void> saveSets(List<WordSet> sets) async {
    final prefs = await SharedPreferences.getInstance();
    final setsJson = sets
        .map((set) => {
              'id': set.id,
              'name': set.name,
              'words': set.words
                  .map((word) => {
                        'id': word.id,
                        'original': word.original,
                        'translation': word.translation,
                      })
                  .toList(),
            })
        .toList();
    await prefs.setString(_setsKey, jsonEncode(setsJson));
  }

  Future<List<WordSet>> loadSets() async {
    final prefs = await SharedPreferences.getInstance();
    final setsJson = prefs.getString(_setsKey);
    if (setsJson == null) return [];
    final List<dynamic> decoded = jsonDecode(setsJson);
    return decoded
        .map((set) => WordSet(
              id: set['id'],
              name: set['name'],
              words: (set['words'] as List)
                  .map((word) => Word(
                        id: word['id'],
                        original: word['original'],
                        translation: word['translation'],
                      ))
                  .toList(),
            ))
        .toList();
  }
}