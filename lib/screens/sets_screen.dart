import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/word_set_provider.dart';
import 'words_editor_screen.dart';
import 'learning_screen.dart';

class SetsScreen extends StatefulWidget {
  const SetsScreen({super.key});

  @override
  _SetsScreenState createState() => _SetsScreenState();
}

class _SetsScreenState extends State<SetsScreen> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WordSetProvider>(context, listen: false).loadSets();
    });
  }

  void _addSet() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Set'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Set Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                Provider.of<WordSetProvider>(context, listen: false)
                    .addSet(_nameController.text);
                _nameController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wordSetProvider = Provider.of<WordSetProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Sets'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Provider.of<AuthProvider>(context, listen: false).signOut(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: wordSetProvider.sets.length,
        itemBuilder: (context, index) {
          final set = wordSetProvider.sets[index];
          return ListTile(
            title: Text(set.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WordsEditorScreen(setId: set.id),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LearningScreen(setId: set.id),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSet,
        child: const Icon(Icons.add),
      ),
    );
  }
}