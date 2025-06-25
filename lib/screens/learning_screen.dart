import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/word_set_provider.dart';

class LearningScreen extends StatefulWidget {
  final String setId;

  const LearningScreen({super.key, required this.setId});

  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  bool _isFlashcardMode = true;
  int _currentIndex = 0;
  bool _showTranslation = false;
  List<String> _options = [];

  void _generateOptions(String correctTranslation, List<String> allTranslations) {
    final random = Random();
    _options = [correctTranslation];
    while (_options.length < 4 && allTranslations.isNotEmpty) {
      final option = allTranslations[random.nextInt(allTranslations.length)];
      if (!_options.contains(option)) _options.add(option);
    }
    _options.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final wordSetProvider = Provider.of<WordSetProvider>(context);
    final set = wordSetProvider.sets.firstWhere((s) => s.id == widget.setId);
    final words = set.words;

    if (words.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(set.name)),
        body: const Center(child: Text('No words in this set')),
      );
    }

    final currentWord = words[_currentIndex];
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
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(blurRadius: 4)],
                  ),
                  child: Text(
                    _showTranslation ? currentWord.translation : currentWord.original,
                    style: const TextStyle(fontSize: 24),
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
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                ..._options.map((option) => ListTile(
                      title: Text(option),
                      onTap: () {
                        if (option == currentWord.translation) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Correct!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Wrong!')),
                          );
                        }
                        setState(() {
                          _currentIndex = (_currentIndex + 1) % words.length;
                          _options = [];
                        });
                      },
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