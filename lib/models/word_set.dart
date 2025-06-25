import 'word.dart';

class WordSet {
  final String id;
  final String name;
  final List<Word> words;

  WordSet({required this.id, required this.name, this.words = const []});

  WordSet copyWith({String? id, String? name, List<Word>? words}) {
    return WordSet(
      id: id ?? this.id,
      name: name ?? this.name,
      words: words ?? this.words,
    );
  }
}