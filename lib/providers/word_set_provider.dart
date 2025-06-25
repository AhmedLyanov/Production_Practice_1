import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/word.dart';
import '../models/word_set.dart';
import '../services/storage_service.dart';

class WordSetProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<WordSet> _sets = [];

  List<WordSet> get sets => _sets;

  Future<void> loadSets() async {
    _sets = await _storageService.loadSets();
    notifyListeners();
  }

  Future<void> addSet(String name) async {
    final newSet = WordSet(id: const Uuid().v4(), name: name);
    _sets = [..._sets, newSet];
    await _storageService.saveSets(_sets);
    notifyListeners();
  }

  Future<void> addWord(String setId, String original, String translation) async {
    final setIndex = _sets.indexWhere((set) => set.id == setId);
    if (setIndex == -1) return;
    final newWord = Word(
      id: const Uuid().v4(),
      original: original,
      translation: translation,
    );
    final updatedSet = _sets[setIndex].copyWith(
      words: [..._sets[setIndex].words, newWord],
    );
    _sets = [..._sets]..[setIndex] = updatedSet;
    await _storageService.saveSets(_sets);
    notifyListeners();
  }
}