import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/word_set_provider.dart';

class WordsEditorScreen extends StatefulWidget {
  final String setId;

  const WordsEditorScreen({super.key, required this.setId});

  @override
  _WordsEditorScreenState createState() => _WordsEditorScreenState();
}

class _WordsEditorScreenState extends State<WordsEditorScreen> {
  final _originalController = TextEditingController();
  final _translationController = TextEditingController();

  void _addWord() {
    if (_originalController.text.isNotEmpty && _translationController.text.isNotEmpty) {
      Provider.of<WordSetProvider>(context, listen: false).addWord(
        widget.setId,
        _originalController.text,
        _translationController.text,
      );
      _originalController.clear();
      _translationController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final wordSetProvider = Provider.of<WordSetProvider>(context);
    final set = wordSetProvider.sets.firstWhere((s) => s.id == widget.setId);

    return Scaffold(
      appBar: AppBar(title: Text('Edit ${set.name}')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _originalController,
                    decoration: const InputDecoration(labelText: 'Original'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _translationController,
                    decoration: const InputDecoration(labelText: 'Translation'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addWord,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: set.words.length,
              itemBuilder: (context, index) {
                final word = set.words[index];
                return ListTile(
                  title: Text(word.original),
                  subtitle: Text(word.translation),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}