class Word {
  final String id;
  final String original;
  final String translation;

  Word({required this.id, required this.original, required this.translation});

  Word copyWith({String? id, String? original, String? translation}) {
    return Word(
      id: id ?? this.id,
      original: original ?? this.original,
      translation: translation ?? this.translation,
    );
  }
}