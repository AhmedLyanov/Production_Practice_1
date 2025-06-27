import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/word_set_provider.dart';
import '../models/word_set.dart'; // Added import for WordSet
import '../models/word.dart'; // Added import for Word

class LearningScreen extends StatefulWidget {
  final String setId;

  const LearningScreen({super.key, required this.setId});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  bool _isFlashcardMode = true;
  int _currentIndex = 0;
  bool _showTranslation = false;
  List<String> _options = [];

  void _generateOptions(String correctTranslation, List<String> allTranslations) {
    _options = [correctTranslation];
    final availableOptions = allTranslations
        .where((t) => t != correctTranslation)
        .toList()
      ..shuffle();
    _options.addAll(availableOptions.take(3));
    _options.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final wordSetProvider = Provider.of<WordSetProvider>(context);
    final set = wordSetProvider.sets.firstWhere(
      (s) => s.id == widget.setId,
      orElse: () => WordSet(id: widget.setId, name: 'Unknown', words: const []),
    );
    final words = set.words;

    if (words.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(set.name)),
        body: const Center(child: Text('No words in this set')),
      );
    }

    final currentWord = words[_currentIndex % words.length];
    if (_options.isEmpty) {
      _generateOptions(currentWord.translation, words.map((w) => w.translation).toList());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(set.name),
        actions: [
          IconButton(
            icon: Icon(_isFlashcardMode ? Icons.quiz : Icons.card_membership),
            onPressed: () {
              setState(() {
                _isFlashcardMode = !_isFlashcardMode;
                _showTranslation = false;
                _options = [];
                _currentIndex = 0; // Reset index to avoid out-of-bounds
              });
            },
          ),
        ],
      ),
      body: _isFlashcardMode
          ? GestureDetector(
              onTap: () => setState(() => _showTranslation = !_showTranslation),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _showTranslation
                          ? [Colors.teal[400]!, Colors.teal[600]!]
                          : [Colors.amber[400]!, Colors.amber[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(blurRadius: 4)],
                  ),
                  child: Text(
                    _showTranslation ? currentWord.translation : currentWord.original,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    currentWord.original,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ..._options.map((option) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          foregroundColor: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          if (words.isEmpty) return; // Prevent action if words are empty
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                option == currentWord.translation ? 'Correct!' : 'Wrong!',
                              ),
                              backgroundColor: option == currentWord.translation
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          );
                          setState(() {
                            _currentIndex = (_currentIndex + 1) % words.length;
                            _options = [];
                          });
                        },
                        child: Text(
                          option,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    )),
              ],
            ),
      floatingActionButton: _isFlashcardMode
          ? FloatingActionButton(
              onPressed: () => setState(() {
                _currentIndex = (_currentIndex + 1) % words.length;
                _showTranslation = false;
              }),
              child: const Icon(Icons.arrow_forward),
            )
          : null,
    );
  }
}