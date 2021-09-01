// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordPair = WordPair.random();

    return MaterialApp(
      title: 'Woah custom fonts!?',
      theme: ThemeData(
        primaryColor: Colors.white,
        fontFamily: 'Inter',
      ),
      home: RandomWords(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.black,
        fontFamily: 'Inter',
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return ListTile(
      title: SelectableText(
        pair.asPascalCase,
        style: TextStyle(
          fontFamily: 'Inter',
        ),
      ),
      leading: CircleAvatar(
        child: Text(
          pair.asPascalCase[0],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.purple : null,
      ),
      onTap: () {
        log('tapped');
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      // padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        if (i >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[i]);
      },
    );
  }

  void _pushSaved() {
    var page = MaterialPageRoute<void>(
      builder: (BuildContext context) {
        final tiles = _saved.map(
          (WordPair pair) {
            return ListTile(
              title: SelectableText(
                pair.asPascalCase,
              ),
            );
          },
        );
        final divided = tiles.isNotEmpty
            ? ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList()
            : <Widget>[];

        return Scaffold(
          appBar: AppBar(
            title: Text('Saved Suggestions'),
          ),
          body: divided.isEmpty
              ? Center(child: Text('No Suggestions Saved'))
              : ListView(children: divided),
        );
      },
    );
    Navigator.of(context).push(page);
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ye', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border_outlined),
            onPressed: _pushSaved,
          ),
        ],
        elevation: 24,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _saved.clear();
            });
          },
          child: Icon(Icons.delete, color: Colors.purple),
          backgroundColor: Colors.white),
      body: _buildSuggestions(),
    );
  }
}
