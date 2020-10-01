import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(DummyApp());

class DummyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dummy App',
      theme: ThemeData(
        primaryColor: Colors.white
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override 
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = TextStyle(fontSize: 18.0);
  final _favourites = Set<WordPair>();
  
  void _pushFavourites() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _favourites.map(
            (WordPair wordPair) {
              return ListTile(
                title: Text(wordPair.asPascalCase, style: _biggerFont)
              );
            }
          );

          final divided = ListTile.divideTiles(context: context, tiles: tiles).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Favourites'),
            ),
            body: ListView(
              children: divided
            )
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dummy App List Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushFavourites),
        ],
        ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(itemBuilder: (context, i){
      if(i.isOdd) return Divider();

      final index = i ~/ 2;
      if(index >= _suggestions.length) {
        _suggestions.addAll(generateWordPairs().take(10));
      }

      return _buildRow(_suggestions[index]);
    });
  }

  Widget _buildRow(WordPair wordPair) {
    final alreadyFavourites = _favourites.contains(wordPair);

    return ListTile(
      title: Text(
        wordPair.asPascalCase, 
        style: _biggerFont
      ),
      trailing: Icon(
        alreadyFavourites ? Icons.favorite : Icons.favorite_border,
        color: alreadyFavourites ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          (alreadyFavourites) ? 
          _favourites.remove(wordPair) : _favourites.add(wordPair);
        });
      },
    );
  }
}